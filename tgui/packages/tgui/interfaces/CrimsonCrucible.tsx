import { useState } from 'react';
import {
  Box,
  Button,
  Divider,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

import { backendSuspendStart, globalStore, useBackend } from '../backend';
import { Window } from '../layouts';

type Project = {
  ref: string;
  name: string;
  description: string;
  mechanics: string;
  cost: number;
  paid: number;
  remaining: number;
  progress: number;
  isLordOnly: boolean;
  accessText: string;
  canContribute: boolean;
  maxContribution: number;
  maxBloodCost: number;
  contributorsText: string;
  contributionText: string;
};

type AvailableProject = {
  type_path: string;
  name: string;
  description: string;
  mechanics: string;
  cost: number;
  isLordOnly: boolean;
  accessText: string;
  accessSeal: string;
  canStart: boolean;
  lockedReason: string;
};

type CrucibleData = {
  bloodLevel: number;
  maxBlood: number;
  committedVitae: number;
  isLord: boolean;
  isVampire: boolean;
  canDepositBlood: boolean;
  maxCupDeposit: number;
  activeProjects: Project[];
  availableProjects: AvailableProject[];
  language?: string;
  i18nOverrides?: Record<string, string> | null;
};

const FALLBACK_LANG = 'en';

const TRANSLATIONS: Record<string, Record<string, string>> = {
  en: {
    windowTitle: 'Crimson Crucible',
    headerTitle: 'CRIMSON CRUCIBLE',
    roleLord: 'Right of Dominion',
    roleVampire: 'Right of Sacrifice',
    roleMortal: 'Living sacrifice',
    expand: 'Expand',
    restore: 'Restore',
    expandTip: 'Expand window to screen',
    restoreTip: 'Restore default window size',
    close: 'Close',
    closeTip: 'Close window',
    bloodInCup: 'Blood in cup: {current} / {max}',
    committed: 'Committed: {n} vitae',
    pourBlood: 'Pour blood',
    giveBlood: 'Give blood',
    availableToPour: 'Available to pour: {n} vitae',
    activeRituals: 'Active Rituals',
    newRituals: 'New Rituals',
    emptyActive: 'The crucible is silent. No ritual has begun.',
    mortalNote:
      "The crucible accepts blood into the cup or into rituals already begun. New rites remain the clan's will.",
    nonLordNote:
      'Only the Methuselah can begin new rituals. Others may fill the cup and aid rituals already in motion.',
    noRituals: 'No rituals are available.',
    direct: 'Direct',
    contribute: 'Contribute',
    cancel: 'Cancel',
    required: 'Required: {n} vitae',
    collected: 'Collected: {n} vitae',
    remaining: 'Remaining: {n} vitae',
    contributors: 'Contributors:',
    description: 'Description',
    mechanics: 'Mechanics',
    cost: 'Cost: {n} vitae',
    start: 'Start',
  },
  ru: {
    windowTitle: 'Багровый Тигель',
    headerTitle: 'БАГРОВЫЙ ТИГЕЛЬ',
    roleLord: 'Право Господства',
    roleVampire: 'Право Жертвы',
    roleMortal: 'Живая жертва',
    expand: 'Развернуть',
    restore: 'Свернуть',
    expandTip: 'Развернуть окно на весь экран',
    restoreTip: 'Восстановить размер окна',
    close: 'Закрыть',
    closeTip: 'Закрыть окно',
    bloodInCup: 'Крови в чаше: {current} / {max}',
    committed: 'Внесено: {n} витаэ',
    pourBlood: 'Налить кровь',
    giveBlood: 'Отдать кровь',
    availableToPour: 'Доступно для вливания: {n} витаэ',
    activeRituals: 'Активные ритуалы',
    newRituals: 'Новые ритуалы',
    emptyActive: 'Тигель безмолвствует. Ни один ритуал не начат.',
    mortalNote:
      'Тигель принимает кровь в чашу или в уже начатые ритуалы. Новые обряды — воля клана.',
    nonLordNote:
      'Только Мафусаил может начинать новые ритуалы. Прочие могут наполнять чашу и помогать уже начатым.',
    noRituals: 'Нет доступных ритуалов.',
    direct: 'Направить',
    contribute: 'Внести',
    cancel: 'Отменить',
    required: 'Требуется: {n} витаэ',
    collected: 'Собрано: {n} витаэ',
    remaining: 'Осталось: {n} витаэ',
    contributors: 'Участники:',
    description: 'Описание',
    mechanics: 'Механика',
    cost: 'Цена: {n} витаэ',
    start: 'Начать',
  },
};

type ProjectLoc = { name: string; description: string; mechanics: string };

const RU_PROJECTS_BY_NAME: Record<string, ProjectLoc> = {
  'Summon Vampyre Servant': {
    name: 'Призвать Вампирского Слугу',
    description:
      'Верный слуга, что будет выполнять рутинные дела за тебя и твоих присных — от труда у подземных горнов до забот по поместью.',
    mechanics: 'Поколение: Неонат — может обратить 1 Тонкокровного — 9 RP',
  },
  'Summon Vampyre Guard': {
    name: 'Призвать Вампирского Стража',
    description:
      'Верный слуга, готовый сражаться за твоё дело или защищать поместье — клинком и щитом, луком и стрелами или хитростью и магией.',
    mechanics: 'Поколение: Неонат — может обратить 1 Тонкокровного — 9 RP',
  },
  'Summon Vampyre Champion': {
    name: 'Призвать Вампирского Поборника',
    description:
      'Верный, одарённый и могущественный поборник — глашатай твоей армии тьмы или диверсант, разрывающий смертных из тени.',
    mechanics: 'Поколение: Анцилла — может обратить 5 Неонатов — 17 RP.',
  },
  'Rite of Stirring': {
    name: 'Обряд Пробуждения',
    description:
      'Древняя кровь шевелится вновь. Забытый шёпот раскатывается по костям земли.',
    mechanics:
      '+2 ко всем характеристикам лорда + 1000 к лимиту витаэ лорда + открывает Поборников',
  },
  'Rite of Reclamation': {
    name: 'Обряд Возвращения',
    description:
      'Долго запертая сила возвращается. Земля, камень и тени вновь склоняются перед своим истинным господином.',
    mechanics:
      '+2 ко всем характеристикам лорда + 1000 к лимиту витаэ лорда + открывает обряды доспехов.',
  },
  'Rite of Dominion': {
    name: 'Обряд Господства',
    description:
      'Завеса времени рвётся. Воля Древнего изливается, опутывая чужаков хваткой Земли.',
    mechanics:
      '+2 ко всем характеристикам лорда + 1000 к лимиту витаэ лорда.',
  },
  'Rite of Sovereignty': {
    name: 'Обряд Владычества',
    description:
      'Лорд обретает целостность. Древняя сила пропитывает каждый камень и каждую жилу — Земля и её владыка едины.',
    mechanics:
      '+2 ко всем характеристикам тралов и лорда + 1000 к лимиту витаэ лорда и тралов. Убивает Солнце и громко возвещает о твоём пришествии.',
  },
  'Wicked Plate': {
    name: 'Скверная Латная Броня',
    description:
      'Призыв полного комплекта вампирского латного доспеха из кристаллизованной крови. Ни сталь, ни серебро, ни спасение не помешают воле Лорда.',
    mechanics: 'Может быть проведено только один раз.',
  },
};

const RU_ACCESS_TEXT: Record<string, string> = {
  "(Methuselah's will)": '(воля Мафусаила)',
  '(open)': '(открыто)',
};

const RU_LOCKED_REASONS: Record<string, string> = {
  'Only the Methuselah can begin new rituals.':
    'Только Мафусаил может начинать новые ритуалы.',
  'The ritual conditions are not fulfilled yet.':
    'Условия ритуала ещё не выполнены.',
  'This project cannot be started.': 'Этот ритуал не может быть начат.',
};

const localizeContributors = (text: string, lang: string): string => {
  if (lang !== 'ru' || !text) return text;
  if (text === 'No one yet') return 'Никого пока';
  return text;
};

const localizeContribution = (text: string, lang: string): string => {
  if (lang !== 'ru' || !text) return text;
  let m: RegExpMatchArray | null;
  if (
    (m = text.match(/^Can direct up to (\d+) vitae; the cup is spent first$/))
  ) {
    return `Могу направить до ${m[1]} витаэ; сначала расходуется чаша`;
  }
  if ((m = text.match(/^Can contribute up to (\d+) vitae$/))) {
    return `Могу внести до ${m[1]} витаэ`;
  }
  if ((m = text.match(/^Will sacrifice (\d+) vitae and (\d+) blood$/))) {
    return `Пожертвую ${m[1]} витаэ и ${m[2]} крови`;
  }
  return text;
};

const localizeActiveProject = (p: Project, lang: string): Project => {
  if (lang !== 'ru') return p;
  const next: Project = { ...p };
  const loc = RU_PROJECTS_BY_NAME[p.name];
  if (loc) {
    next.name = loc.name;
    next.description = loc.description;
    next.mechanics = loc.mechanics;
  }
  if (p.accessText && RU_ACCESS_TEXT[p.accessText]) {
    next.accessText = RU_ACCESS_TEXT[p.accessText];
  }
  next.contributorsText = localizeContributors(p.contributorsText, lang);
  next.contributionText = localizeContribution(p.contributionText, lang);
  return next;
};

const localizeAvailableProject = (
  p: AvailableProject,
  lang: string,
): AvailableProject => {
  if (lang !== 'ru') return p;
  const next: AvailableProject = { ...p };
  const loc = RU_PROJECTS_BY_NAME[p.name];
  if (loc) {
    next.name = loc.name;
    next.description = loc.description;
    next.mechanics = loc.mechanics;
  }
  if (p.accessText && RU_ACCESS_TEXT[p.accessText]) {
    next.accessText = RU_ACCESS_TEXT[p.accessText];
  }
  if (p.lockedReason && RU_LOCKED_REASONS[p.lockedReason]) {
    next.lockedReason = RU_LOCKED_REASONS[p.lockedReason];
  }
  return next;
};

const resolveLang = (raw: string | undefined): string => {
  if (raw && TRANSLATIONS[raw]) {
    return raw;
  }
  return FALLBACK_LANG;
};

const makeT =
  (lang: string, overrides?: Record<string, string> | null) =>
  (key: string, vars?: Record<string, string | number>): string => {
    let value: string | undefined = overrides ? overrides[key] : undefined;
    if (value === undefined) {
      const dict = TRANSLATIONS[lang] || TRANSLATIONS[FALLBACK_LANG];
      value = dict[key];
    }
    if (value === undefined) {
      value = TRANSLATIONS[FALLBACK_LANG][key];
    }
    if (value === undefined) {
      return key;
    }
    if (vars) {
      for (const name of Object.keys(vars)) {
        value = value.replace(`{${name}}`, String(vars[name]));
      }
    }
    return value;
  };

type Translator = ReturnType<typeof makeT>;

const formatVitae = (value: number) =>
  Math.round(value || 0).toLocaleString('en-US');

const formatPercent = (value: number) =>
  `${Number(value || 0).toLocaleString('en-US', {
    maximumFractionDigits: 1,
  })}%`;

const clampRatio = (value: number) => Math.max(0, Math.min(1, value || 0));

const defaultWindowWidth = 1680;
const defaultWindowHeight = 920;

const setCrucibleWindowSize = (expanded: boolean) => {
  const scale = window.devicePixelRatio || 1;
  const screenWidth = Math.floor(window.screen.availWidth * scale);
  const screenHeight = Math.floor(window.screen.availHeight * scale);
  const width = expanded
    ? screenWidth
    : Math.min(defaultWindowWidth, screenWidth);
  const height = expanded
    ? screenHeight
    : Math.min(defaultWindowHeight, screenHeight);
  const x = expanded ? 0 : Math.max(Math.floor((screenWidth - width) / 2), 0);
  const y = expanded ? 0 : Math.max(Math.floor((screenHeight - height) / 2), 0);

  Byond.winset(Byond.windowId, {
    pos: `${x},${y}`,
    size: `${width}x${height}`,
  });
};

const closeCrucibleWindow = () => {
  globalStore.dispatch(backendSuspendStart());
};

const shellStyle = {
  background:
    'linear-gradient(180deg, rgba(24, 3, 5, 0.95), rgba(8, 7, 7, 0.98))',
  display: 'grid',
  gap: '8px',
  gridTemplateRows: '136px minmax(0, 1fr)',
  height: '100%',
  minHeight: 0,
};

const frameStyle = {
  background:
    'linear-gradient(135deg, rgba(45, 5, 8, 0.95), rgba(12, 10, 10, 0.96))',
  border: '1px solid #5b1b1f',
  borderRadius: '6px',
  boxShadow: 'inset 0 0 18px rgba(0, 0, 0, 0.55)',
};

const headerGridStyle = {
  ...frameStyle,
  alignItems: 'center',
  display: 'grid',
  gap: '16px',
  gridTemplateColumns: '210px minmax(320px, 1fr) minmax(280px, 340px)',
  padding: '14px',
};

const sealControlStyle = {
  alignItems: 'center',
  display: 'grid',
  gap: '10px',
  gridTemplateColumns: '64px minmax(118px, 1fr)',
};

const windowControlStackStyle = {
  display: 'grid',
  gap: '6px',
};

const windowControlButtonStyle = {
  border: '1px solid rgba(232, 208, 160, 0.5)',
  boxShadow: '0 0 10px rgba(216, 32, 52, 0.2)',
  fontWeight: 700,
};

const contentGridStyle = {
  display: 'grid',
  gap: '8px',
  gridTemplateColumns: 'minmax(660px, 2.25fr) minmax(460px, 1fr)',
  height: '100%',
  minHeight: 0,
};

const parchmentStyle = {
  background: 'linear-gradient(180deg, #c9b98d, #a99461)',
  border: '1px solid #1f1614',
  borderRadius: '6px',
  color: '#17110f',
  boxShadow: 'inset 0 0 12px rgba(255, 246, 190, 0.22)',
};

const activeCardStyle = {
  ...parchmentStyle,
  minWidth: 0,
  padding: '10px',
};

const availableCardStyle = {
  ...parchmentStyle,
  display: 'grid',
  gap: '8px',
  minWidth: 0,
  padding: '10px',
};

const sealStyle = {
  width: '52px',
  height: '52px',
  borderRadius: '6px',
  border: '1px solid #572126',
  background: 'radial-gradient(circle at 50% 35%, #611820, #18090b 74%)',
  color: '#d8c7a0',
  textAlign: 'center' as const,
  lineHeight: '52px',
  fontWeight: 700,
  fontSize: '21px',
  textShadow: '0 0 8px #d82034',
};

const labelStyle = {
  color: '#3a2723',
  fontSize: '11px',
  fontWeight: 700,
  textTransform: 'uppercase' as const,
};

const descriptionBlockStyle = {
  borderTop: '1px solid rgba(74, 52, 35, 0.35)',
  paddingTop: '7px',
};

const copyStyle = {
  color: '#2f211e',
  lineHeight: 1.35,
  overflowWrap: 'break-word' as const,
};

const mechanicsBlockStyle = {
  background:
    'linear-gradient(90deg, rgba(112, 64, 184, 0.2), rgba(112, 64, 184, 0.06))',
  borderLeft: '4px solid #7040b8',
  marginTop: '8px',
  padding: '7px 9px 7px 10px',
};

const mechanicsLabelStyle = {
  ...labelStyle,
  color: '#5b239b',
};

const mechanicsStyle = {
  color: '#7040b8',
  fontStyle: 'normal',
  fontWeight: 400,
  lineHeight: 1.35,
  overflowWrap: 'break-word' as const,
  whiteSpace: 'pre-line' as const,
};

export const CrimsonCrucible = () => {
  const { act, data } = useBackend<CrucibleData>();
  const [windowExpanded, setWindowExpanded] = useState(false);
  const {
    bloodLevel = 0,
    maxBlood = 20000,
    committedVitae = 0,
    isLord = false,
    isVampire = false,
    canDepositBlood = false,
    maxCupDeposit = 0,
    activeProjects = [],
    availableProjects = [],
  } = data;
  const lang = resolveLang(data.language);
  const t = makeT(lang, data.i18nOverrides);
  const localizedActiveProjects = activeProjects.map((p) =>
    localizeActiveProject(p, lang),
  );
  const localizedAvailableProjects = availableProjects.map((p) =>
    localizeAvailableProject(p, lang),
  );
  const bloodRatio = clampRatio(bloodLevel / Math.max(maxBlood, 1));
  const roleText = isVampire
    ? isLord
      ? t('roleLord')
      : t('roleVampire')
    : t('roleMortal');
  const toggleWindowSize = () => {
    const nextExpanded = !windowExpanded;
    setCrucibleWindowSize(nextExpanded);
    setWindowExpanded(nextExpanded);
  };

  return (
    <Window
      title={t('windowTitle')}
      width={defaultWindowWidth}
      height={defaultWindowHeight}
      theme="dark"
    >
      <Window.Content fitted>
        <Box p={1} style={shellStyle}>
          <Box style={headerGridStyle}>
            <Box style={sealControlStyle}>
              <Box style={sealStyle}>V</Box>
              <Box style={windowControlStackStyle}>
                <Button
                  fluid
                  color="gold"
                  icon={windowExpanded ? 'compress' : 'expand'}
                  tooltip={windowExpanded ? t('restoreTip') : t('expandTip')}
                  tooltipPosition="right"
                  onClick={toggleWindowSize}
                  style={windowControlButtonStyle}
                >
                  {windowExpanded ? t('restore') : t('expand')}
                </Button>
                <Button
                  fluid
                  color="red"
                  icon="times"
                  tooltip={t('closeTip')}
                  tooltipPosition="right"
                  onClick={closeCrucibleWindow}
                  style={windowControlButtonStyle}
                >
                  {t('close')}
                </Button>
              </Box>
            </Box>
            <Box>
              <Box
                bold
                fontSize={1.65}
                color="#e0c090"
                textAlign="center"
                style={{ letterSpacing: '0' }}
              >
                {t('headerTitle')}
              </Box>
              <Box color="#c8878d" textAlign="center" mt={0.3}>
                {roleText}
              </Box>
            </Box>
            <Box>
              <Box color="#e8d0a0" mb={0.4}>
                {t('bloodInCup', {
                  current: formatVitae(bloodLevel),
                  max: formatVitae(maxBlood),
                })}
              </Box>
              <ProgressBar
                value={bloodRatio}
                ranges={{
                  good: [0.66, Infinity],
                  average: [0.25, 0.66],
                  bad: [-Infinity, 0.25],
                }}
              />
              <Box color="#b99b7c" mt={0.4}>
                {t('committed', { n: formatVitae(committedVitae) })}
              </Box>
              <Button
                fluid
                color="red"
                mt={0.6}
                disabled={!canDepositBlood}
                onClick={() => act('deposit_blood')}
              >
                {isVampire ? t('pourBlood') : t('giveBlood')}
              </Button>
              <Box color="#b99b7c" mt={0.4} fontSize={0.9}>
                {t('availableToPour', { n: formatVitae(maxCupDeposit) })}
              </Box>
            </Box>
          </Box>
          <Box style={contentGridStyle}>
            <Section title={t('activeRituals')} fill scrollable>
              {localizedActiveProjects.length ? (
                localizedActiveProjects.map((project, index) => (
                  <ActiveProjectCard
                    key={project.ref}
                    index={index}
                    isLord={isLord}
                    project={project}
                    onContribute={() => act('contribute', { ref: project.ref })}
                    onCancel={() => act('cancel_project', { ref: project.ref })}
                    t={t}
                  />
                ))
              ) : (
                <EmptyState text={t('emptyActive')} />
              )}
            </Section>
            <Section title={t('newRituals')} fill scrollable>
              {!isVampire ? (
                <Box color="#c7a97a" italic mb={1}>
                  {t('mortalNote')}
                </Box>
              ) : !isLord ? (
                <Box color="#c7a97a" italic mb={1}>
                  {t('nonLordNote')}
                </Box>
              ) : null}
              {isVampire && isLord && localizedAvailableProjects.length ? (
                localizedAvailableProjects.map((project) => (
                  <AvailableProjectCard
                    key={project.type_path}
                    project={project}
                    onStart={() =>
                      act('start_project', { type_path: project.type_path })
                    }
                    t={t}
                  />
                ))
              ) : isVampire && isLord ? (
                <EmptyState text={t('noRituals')} />
              ) : null}
            </Section>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};

type ProjectCopyProps = {
  description: string;
  mechanics?: string;
  t: Translator;
};

const ProjectCopy = (props: ProjectCopyProps) => {
  const { description, mechanics, t } = props;

  return (
    <Box mt={0.7}>
      <Box style={descriptionBlockStyle}>
        <Box style={labelStyle}>{t('description')}</Box>
        <Box mt={0.2} style={copyStyle}>
          {description}
        </Box>
      </Box>
      {!!mechanics && (
        <Box style={mechanicsBlockStyle}>
          <Box style={mechanicsLabelStyle}>{t('mechanics')}</Box>
          <Box mt={0.2} style={mechanicsStyle}>
            {mechanics}
          </Box>
        </Box>
      )}
    </Box>
  );
};

type ActiveProjectCardProps = {
  index: number;
  isLord: boolean;
  project: Project;
  onContribute: () => void;
  onCancel: () => void;
  t: Translator;
};

const ActiveProjectCard = (props: ActiveProjectCardProps) => {
  const { index, isLord, project, onContribute, onCancel, t } = props;
  const ratio = clampRatio(project.paid / Math.max(project.cost, 1));

  return (
    <Box mb={1} style={activeCardStyle}>
      <Stack align="start">
        <Stack.Item>
          <Box style={sealStyle}>{index + 1}</Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box bold fontSize={1.08}>
            {project.name} {project.accessText}
          </Box>
          <ProjectCopy
            description={project.description}
            mechanics={project.mechanics}
            t={t}
          />
        </Stack.Item>
        <Stack.Item width="128px">
          <Button
            fluid
            color="red"
            disabled={!project.canContribute}
            onClick={onContribute}
          >
            {isLord ? t('direct') : t('contribute')}
          </Button>
          {isLord && (
            <Button fluid color="bad" mt={0.5} onClick={onCancel}>
              {t('cancel')}
            </Button>
          )}
        </Stack.Item>
      </Stack>
      <Divider />
      <Stack>
        <Stack.Item grow>
          <Box>{t('required', { n: formatVitae(project.cost) })}</Box>
          <Box>{t('collected', { n: formatVitae(project.paid) })}</Box>
          <Box>{t('remaining', { n: formatVitae(project.remaining) })}</Box>
        </Stack.Item>
      </Stack>
      <Box mt={0.8}>
        <ProgressBar value={ratio} color="red">
          {formatPercent(project.progress)}
        </ProgressBar>
      </Box>
      <Box color="#563f37" mt={0.5} fontSize={0.9}>
        {t('contributors')} {project.contributorsText}
      </Box>
      {project.canContribute && (
        <Box color="#563f37" mt={0.3} fontSize={0.9}>
          {project.contributionText}
        </Box>
      )}
    </Box>
  );
};

type AvailableProjectCardProps = {
  project: AvailableProject;
  onStart: () => void;
  t: Translator;
};

const AvailableProjectCard = (props: AvailableProjectCardProps) => {
  const { project, onStart, t } = props;

  return (
    <Box mb={1} style={availableCardStyle}>
      <Stack align="center">
        <Stack.Item>
          <Box style={sealStyle}>{project.accessSeal}</Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box bold fontSize={1.08}>
            {project.name} {project.accessText}
          </Box>
        </Stack.Item>
      </Stack>
      <ProjectCopy
        description={project.description}
        mechanics={project.mechanics}
        t={t}
      />
      <Stack align="center" mt={0.3}>
        <Stack.Item grow>
          <Box color="#563f37">
            {t('cost', { n: formatVitae(project.cost) })}
          </Box>
          {!project.canStart && (
            <Box color="#6c1f25" mt={0.4} fontSize={0.9}>
              {project.lockedReason}
            </Box>
          )}
        </Stack.Item>
        <Stack.Item width="112px">
          <Button
            fluid
            color="red"
            disabled={!project.canStart}
            onClick={onStart}
          >
            {t('start')}
          </Button>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const EmptyState = ({ text }: { text: string }) => (
  <Box
    italic
    textAlign="center"
    color="#b99b7c"
    p={2}
    style={{
      border: '1px dashed #5b1b1f',
      borderRadius: '6px',
      background: 'rgba(24, 6, 7, 0.45)',
    }}
  >
    {text}
  </Box>
);
