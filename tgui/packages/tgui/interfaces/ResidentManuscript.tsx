import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Divider,
  Input,
  Stack,
  TextArea,
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
  owner_status: string;
  expiry_date: string;
  issued_place: string;
  description: string;
  seal_chancellor: SealData;
  seal_elder: SealData;
  seal_duke: SealData;
  seal_hand: SealData;
  is_owner: boolean;
  is_bound: boolean;
  can_edit_fake: boolean;
  can_detect: boolean;
  detection_done: boolean;
  detection_result: string;
  detection_note: string;
  defect_note: string;
};

const IVORY = '#f3e8cc';
const IVORY_LIGHT = '#faf2dc';
const IVORY_DARK = '#e2d3ae';
const PARCHMENT_SHADOW = '#d8c89c';
const GOLD_LEAF = '#b59440';
const GOLD_LEAF_DARK = '#7c5e1a';
const GOLD_FAINT = 'rgba(124, 94, 26, 0.3)';
const INK = '#1a1a30';
const INK_FAINT = 'rgba(26, 26, 48, 0.55)';
const LAZURITE = '#1e3a8a';
const CINNABAR = '#8b1a1a';
const CINNABAR_DEEP = '#6e1414';

const shellStyle: React.CSSProperties = {
  width: '100%',
  height: '100%',
  padding: '18px 22px',
  background: `
    radial-gradient(ellipse at 15% 10%, ${IVORY_LIGHT} 0%, transparent 55%),
    radial-gradient(ellipse at 85% 90%, ${PARCHMENT_SHADOW} 0%, transparent 60%),
    radial-gradient(ellipse at 50% 50%, ${IVORY} 0%, ${IVORY_DARK} 100%)
  `,
  color: INK,
  fontFamily: '"Palatino Linotype", Palatino, "Times New Roman", Georgia, serif',
  display: 'flex',
  flexDirection: 'column',
  gap: '10px',
  boxShadow: `inset 0 0 100px rgba(124, 94, 26, 0.25), inset 0 0 6px ${GOLD_LEAF_DARK}`,
  border: `3px double ${GOLD_LEAF_DARK}`,
  outline: `1px solid ${GOLD_LEAF}`,
  outlineOffset: '-6px',
};

const titleStyle: React.CSSProperties = {
  textAlign: 'center',
  fontSize: '26px',
  letterSpacing: '8px',
  fontVariant: 'small-caps',
  fontWeight: 'bold',
  color: CINNABAR_DEEP,
  paddingBottom: '6px',
  borderBottom: `1px solid ${GOLD_LEAF_DARK}`,
  fontFamily: '"Palatino Linotype", "Times New Roman", serif',
  textShadow: '0 1px 0 rgba(180, 148, 64, 0.25)',
};

const subtitleStyle: React.CSSProperties = {
  textAlign: 'center',
  fontSize: '11px',
  letterSpacing: '4px',
  fontVariant: 'small-caps',
  color: LAZURITE,
  marginTop: '4px',
  fontStyle: 'italic',
};

const fieldRow: React.CSSProperties = {
  display: 'flex',
  padding: '5px 0',
  borderBottom: `1px dashed ${GOLD_FAINT}`,
  fontSize: '13px',
};

const fieldLabel: React.CSSProperties = {
  flex: '0 0 145px',
  fontVariant: 'small-caps',
  letterSpacing: '2px',
  color: GOLD_LEAF_DARK,
  fontStyle: 'italic',
};

const fieldValue: React.CSSProperties = {
  color: INK,
  flex: 1,
  fontWeight: 'bold',
};

const descriptionStyle: React.CSSProperties = {
  fontSize: '12px',
  lineHeight: '1.85em',
  color: INK,
  textAlign: 'justify',
  padding: '12px 16px',
  border: `1px solid ${GOLD_FAINT}`,
  background: 'rgba(255, 248, 215, 0.35)',
  fontStyle: 'italic',
  textIndent: '1.8em',
};

const sealCell: React.CSSProperties = {
  border: `1px solid ${GOLD_FAINT}`,
  padding: '6px 4px',
  textAlign: 'center',
  background: 'rgba(255, 248, 215, 0.45)',
  minHeight: '74px',
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'space-between',
};

const sealLabel: React.CSSProperties = {
  fontSize: '10px',
  letterSpacing: '2px',
  fontVariant: 'small-caps',
  color: GOLD_LEAF_DARK,
};

const sealStamp: React.CSSProperties = {
  color: CINNABAR,
  fontSize: '11px',
  fontVariant: 'small-caps',
  letterSpacing: '1px',
  fontWeight: 'bold',
  border: `2px double ${CINNABAR}`,
  borderRadius: '50%',
  width: '42px',
  height: '42px',
  margin: '4px auto',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  transform: 'rotate(-8deg)',
  textShadow: '0 0 2px rgba(139, 26, 26, 0.3)',
  background: 'rgba(139, 26, 26, 0.1)',
  boxShadow: '0 0 4px rgba(139, 26, 26, 0.15)',
};

const sealMissing: React.CSSProperties = {
  color: INK_FAINT,
  fontSize: '9px',
  fontStyle: 'italic',
  margin: '8px 0',
};

const sealStamperLabel: React.CSSProperties = {
  fontSize: '8px',
  color: GOLD_LEAF_DARK,
  letterSpacing: '0.5px',
};

const footerBox: React.CSSProperties = {
  fontSize: '10px',
  color: INK_FAINT,
  fontStyle: 'italic',
  textAlign: 'center',
};

const defectNote: React.CSSProperties = {
  color: '#8a1a1a',
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
    owner_status,
    expiry_date,
    issued_place,
    description,
    seal_chancellor,
    seal_elder,
    seal_duke,
    seal_hand,
    is_owner,
    is_bound,
    can_edit_fake,
    can_detect,
    detection_done,
    detection_result,
    detection_note,
    defect_note,
  } = data;

  const [draftOwnerName, setDraftOwnerName] = useState(owner_name || '');
  const [draftOwnerStatus, setDraftOwnerStatus] = useState(
    owner_status || 'Безызвестное',
  );
  const [draftExpiryDate, setDraftExpiryDate] = useState(expiry_date || '');
  const [draftIssuedPlace, setDraftIssuedPlace] = useState(issued_place || '');
  const [draftDescription, setDraftDescription] = useState(description || '');

  useEffect(() => {
    setDraftOwnerName(owner_name || '');
    setDraftOwnerStatus(owner_status || 'Безызвестное');
    setDraftExpiryDate(expiry_date || '');
    setDraftIssuedPlace(issued_place || '');
    setDraftDescription(description || '');
  }, [owner_name, owner_status, expiry_date, issued_place, description]);

  const saveFakeManuscript = () => {
    act('save_fake', {
      owner_name: draftOwnerName,
      owner_status: draftOwnerStatus,
      expiry_date: draftExpiryDate,
      issued_place: draftIssuedPlace,
      description: draftDescription,
    });
  };

  return (
    <Window
      width={560}
      height={680}
      title="Подорожная грамота"
      theme="blackstone"
    >
      <Window.Content scrollable>
        <Box style={shellStyle}>
          <Box>
            <Box style={titleStyle}>Подорожная грамота</Box>
            <Box style={subtitleStyle}>
              ~ Под Рукой Короны ~{' '}
              {can_edit_fake ? draftIssuedPlace || '—' : issued_place} ~
            </Box>
          </Box>

          <Box>
            <Box style={fieldRow}>
              <Box style={fieldLabel}>Имя</Box>
              <Box style={fieldValue}>
                {can_edit_fake ? (
                  <Input
                    fluid
                    maxLength={64}
                    value={draftOwnerName}
                    onChange={setDraftOwnerName}
                    placeholder="Имя владельца"
                  />
                ) : (
                  owner_name || '—'
                )}
              </Box>
            </Box>
            <Box style={fieldRow}>
              <Box style={fieldLabel}>Сословие</Box>
              <Box style={fieldValue}>
                {can_edit_fake ? (
                  <Input
                    fluid
                    maxLength={64}
                    value={draftOwnerStatus}
                    onChange={setDraftOwnerStatus}
                    placeholder="Сословие"
                  />
                ) : (
                  owner_status || '—'
                )}
              </Box>
            </Box>
            <Box style={fieldRow}>
              <Box style={fieldLabel}>Дана впредь до..</Box>
              <Box style={fieldValue}>
                {can_edit_fake ? (
                  <Input
                    fluid
                    maxLength={64}
                    value={draftExpiryDate}
                    onChange={setDraftExpiryDate}
                    placeholder="Дата"
                  />
                ) : (
                  expiry_date || '—'
                )}
              </Box>
            </Box>
            {can_edit_fake && (
              <Box style={fieldRow}>
                <Box style={fieldLabel}>Место выдачи</Box>
                <Box style={fieldValue}>
                  <Input
                    fluid
                    maxLength={64}
                    value={draftIssuedPlace}
                    onChange={setDraftIssuedPlace}
                    placeholder="Место выдачи"
                  />
                </Box>
              </Box>
            )}
          </Box>

          <Box style={descriptionStyle}>
            {can_edit_fake ? (
              <TextArea
                fluid
                height="130px"
                maxLength={1200}
                value={draftDescription}
                onChange={setDraftDescription}
                dontUseTabForIndent
              />
            ) : (
              description
            )}
          </Box>

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
                      detection_result === 'fake' ? '#8a1a1a' : '#2d5a3d',
                    marginTop: '2px',
                    fontWeight: 'bold',
                  }}
                >
                  {detection_result === 'fake'
                    ? 'Сдаётся вам, что грамота поддельна.'
                    : detection_result === 'real'
                      ? detection_note || 'На ваш взгляд грамота подлинна.'
                      : detection_note ||
                        'На ваш взгляд грамота не вызывает подозрений.'}
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              {can_edit_fake && (
                <Button
                  icon="save"
                  color="good"
                  onClick={saveFakeManuscript}
                  tooltip="Сохранить заполненную подделку"
                >
                  Сохранить
                </Button>
              )}
              {can_detect && (
                <Button
                  icon="search"
                  onClick={() => act('detect')}
                  tooltip="Тайно изучить грамоту на предмет подделки"
                >
                  Изучить
                </Button>
              )}
              {!is_bound && !can_edit_fake && (
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
