import {
  Box,
  Button,
  Divider,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type SealData = {
  label: string;
  stamped: boolean;
  stamper: string;
};

type Data = {
  owner_name: string;
  owner_age: string;
  owner_status: string;
  expiry_date: string;
  issued_place: string;
  description: string;
  portrait_data: string;
  seal_chancellor: SealData;
  seal_elder: SealData;
  seal_duke: SealData;
  seal_hand: SealData;
  is_owner: boolean;
  is_bound: boolean;
  can_detect: boolean;
  detection_done: boolean;
  detection_result: string;
  defect_note: string;
};

const GOLD = '#d4b477';
const GOLD_FAINT = '#8f7a54';
const GOLD_DIM = 'rgba(170, 130, 70, 0.35)';
const STONE_DARK = '#12100c';
const STONE_MID = '#1f1a14';
const INK_RED = '#8a1a1a';

const shellStyle: React.CSSProperties = {
  width: '100%',
  height: '100%',
  padding: '12px',
  background: `linear-gradient(160deg, ${STONE_MID} 0%, ${STONE_DARK} 100%)`,
  color: GOLD,
  fontFamily: 'Georgia, "Palatino Linotype", Palatino, serif',
  display: 'flex',
  flexDirection: 'column',
  gap: '10px',
};

const titleStyle: React.CSSProperties = {
  textAlign: 'center',
  fontSize: '20px',
  letterSpacing: '5px',
  fontVariant: 'small-caps',
  fontWeight: 'bold',
  color: GOLD,
  paddingBottom: '6px',
  borderBottom: `1px solid ${GOLD_DIM}`,
  textShadow: '0 0 6px rgba(212, 180, 119, 0.3)',
};

const subtitleStyle: React.CSSProperties = {
  textAlign: 'center',
  fontSize: '10px',
  letterSpacing: '3px',
  fontVariant: 'small-caps',
  color: GOLD_FAINT,
  marginTop: '-2px',
};

const portraitFrame: React.CSSProperties = {
  width: '96px',
  height: '96px',
  border: `2px solid ${GOLD_DIM}`,
  background: '#0a0806',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  boxShadow: `inset 0 0 12px rgba(0,0,0,0.7), 0 0 4px ${GOLD_DIM}`,
};

const portraitImage: React.CSSProperties = {
  width: '88px',
  height: '88px',
  imageRendering: 'pixelated',
  objectFit: 'cover',
  objectPosition: 'top',
};

const portraitEmpty: React.CSSProperties = {
  fontSize: '10px',
  color: GOLD_FAINT,
  fontStyle: 'italic',
  letterSpacing: '1px',
  textAlign: 'center',
  padding: '6px',
};

const descriptionStyle: React.CSSProperties = {
  fontSize: '12px',
  lineHeight: '1.6em',
  color: '#c9b188',
  textAlign: 'justify',
  padding: '8px 10px',
  border: `1px solid ${GOLD_DIM}`,
  background: 'rgba(40, 32, 22, 0.5)',
  fontStyle: 'italic',
};

const sealCell: React.CSSProperties = {
  border: `1px solid ${GOLD_DIM}`,
  padding: '6px 4px',
  textAlign: 'center',
  background: 'rgba(30, 24, 16, 0.6)',
  minHeight: '74px',
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'space-between',
};

const sealLabel: React.CSSProperties = {
  fontSize: '10px',
  letterSpacing: '2px',
  fontVariant: 'small-caps',
  color: GOLD_FAINT,
};

const sealStamp: React.CSSProperties = {
  color: INK_RED,
  fontSize: '11px',
  fontVariant: 'small-caps',
  letterSpacing: '1px',
  fontWeight: 'bold',
  border: `2px double ${INK_RED}`,
  borderRadius: '50%',
  width: '40px',
  height: '40px',
  margin: '4px auto',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  transform: 'rotate(-8deg)',
  textShadow: '0 0 2px rgba(138, 26, 26, 0.4)',
};

const sealMissing: React.CSSProperties = {
  color: GOLD_FAINT,
  fontSize: '9px',
  fontStyle: 'italic',
  margin: '8px 0',
};

const sealStamperLabel: React.CSSProperties = {
  fontSize: '8px',
  color: GOLD_FAINT,
  letterSpacing: '0.5px',
};

const footerBox: React.CSSProperties = {
  fontSize: '10px',
  color: GOLD_FAINT,
  fontStyle: 'italic',
  textAlign: 'center',
};

const defectNote: React.CSSProperties = {
  color: '#c06060',
  fontSize: '10px',
  fontStyle: 'italic',
  textAlign: 'center',
  marginTop: '4px',
};

const renderSeal = (seal: SealData) => (
  <Box style={sealCell}>
    <Box style={sealLabel}>{seal.label}</Box>
    {seal.stamped ? (
      <>
        <Box style={sealStamp}>Печать</Box>
        <Box style={sealStamperLabel}>{seal.stamper}</Box>
      </>
    ) : (
      <Box style={sealMissing}>— не заверено —</Box>
    )}
  </Box>
);

export const ResidentManuscript = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    owner_name,
    owner_age,
    owner_status,
    expiry_date,
    issued_place,
    description,
    portrait_data,
    seal_chancellor,
    seal_elder,
    seal_duke,
    seal_hand,
    is_owner,
    is_bound,
    can_detect,
    detection_done,
    detection_result,
    defect_note,
  } = data;

  return (
    <Window
      width={560}
      height={620}
      title="Грамота Личности"
      theme="blackstone"
    >
      <Window.Content>
        <Box style={shellStyle}>
          <Box>
            <Box style={titleStyle}>Грамота Личности</Box>
            <Box style={subtitleStyle}>
              — Под Рукой Короны — {issued_place} —
            </Box>
          </Box>

          <Stack>
            <Stack.Item>
              <Box style={portraitFrame}>
                {portrait_data ? (
                  <img
                    src={`data:image/png;base64,${portrait_data}`}
                    style={portraitImage}
                    alt="portrait"
                  />
                ) : (
                  <Box style={portraitEmpty}>
                    Образ
                    <br />
                    не запечатлён
                  </Box>
                )}
              </Box>
            </Stack.Item>
            <Stack.Item grow>
              <Section fill>
                <LabeledList>
                  <LabeledList.Item label="Имя">
                    {owner_name || '—'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Возраст">
                    {owner_age || '—'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Сословие">
                    {owner_status || '—'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Истекает">
                    {expiry_date || '—'}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Stack.Item>
          </Stack>

          <Box style={descriptionStyle}>{description}</Box>

          <Box
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(4, 1fr)',
              gap: '6px',
            }}
          >
            {renderSeal(seal_chancellor)}
            {renderSeal(seal_elder)}
            {renderSeal(seal_duke)}
            {renderSeal(seal_hand)}
          </Box>

          <Divider />

          <Stack align="center">
            <Stack.Item grow>
              <Box style={footerBox}>
                {is_bound
                  ? is_owner
                    ? 'Грамота признана вашей.'
                    : 'Грамота принадлежит иному.'
                  : 'Грамота ещё не скреплена с ликом владельца.'}
              </Box>
              {!!defect_note && <Box style={defectNote}>{defect_note}</Box>}
              {detection_done && (
                <Box
                  style={{
                    ...footerBox,
                    color:
                      detection_result === 'fake' ? '#c06060' : '#90b070',
                    marginTop: '2px',
                    fontWeight: 'bold',
                  }}
                >
                  {detection_result === 'fake'
                    ? 'Сдаётся вам, что грамота поддельна.'
                    : detection_result === 'real'
                      ? 'На ваш взгляд грамота подлинна.'
                      : 'Вы не можете распознать подделку.'}
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              {can_detect && (
                <Button
                  icon="search"
                  onClick={() => act('detect')}
                  tooltip="Тайно изучить грамоту на предмет подделки"
                >
                  Изучить
                </Button>
              )}
              {!is_bound && (
                <Button
                  icon="link"
                  color="good"
                  onClick={() => act('bind')}
                  tooltip="Скрепить грамоту со своим ликом"
                >
                  Скрепить
                </Button>
              )}
            </Stack.Item>
          </Stack>
        </Box>
      </Window.Content>
    </Window>
  );
};
