import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Divider,
  Input,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type SealData = {
  label: string;
  stamped: boolean;
  stamper: string;
  visible: boolean;
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
  can_become_resident: boolean;
  can_detect: boolean;
  detection_done: boolean;
  detection_result: string;
  detection_note: string;
  defect_note: string;
  defect_notes: string[];
};

type DefectKind =
  | 'ink_blot'
  | 'seal_ink_smudge'
  | 'owner_letter_wobble'
  | 'ragged_parchment_edge'
  | 'uncertain_signature'
  | 'stale_parchment_smell'
  | 'lapis_initial_misaligned'
  | 'misruled_pricking'
  | 'gold_edge_cut'
  | 'rethreaded_cord'
  | 'reheated_wax'
  | 'blue_ink_halo'
  | 'corrected_date'
  | 'heretical_marginalia'
  | 'generic';

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
const HANDWRITTEN_FONT =
  '"MarkScript-Regular", "Segoe Script", "Lucida Calligraphy", cursive';
const STATUS_OPTIONS = ['Безызвестное', 'Под милостью Астраты'];

const shellStyle: React.CSSProperties = {
  width: '100%',
  minHeight: '100%',
  height: 'auto',
  boxSizing: 'border-box',
  position: 'relative',
  overflow: 'hidden',
  padding: '24px 28px',
  background: `
    radial-gradient(ellipse at 15% 10%, ${IVORY_LIGHT} 0%, transparent 55%),
    radial-gradient(ellipse at 85% 90%, ${PARCHMENT_SHADOW} 0%, transparent 60%),
    radial-gradient(ellipse at 50% 50%, ${IVORY} 0%, ${IVORY_DARK} 100%)
  `,
  color: INK,
  fontFamily: '"Palatino Linotype", Palatino, "Times New Roman", Georgia, serif',
  display: 'flex',
  flexDirection: 'column',
  gap: '12px',
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
  fontFamily: HANDWRITTEN_FONT,
  fontSize: '16px',
  fontWeight: 'normal',
};

const descriptionStyle: React.CSSProperties = {
  fontFamily: HANDWRITTEN_FONT,
  fontSize: '17px',
  lineHeight: '1.55em',
  flexGrow: 1,
  minHeight: '250px',
  color: INK,
  textAlign: 'justify',
  padding: '12px 16px',
  border: `1px solid ${GOLD_FAINT}`,
  background: 'rgba(255, 248, 215, 0.35)',
  fontStyle: 'normal',
  textIndent: '1.8em',
};

const manuscriptInputStyle: React.CSSProperties = {
  fontFamily: HANDWRITTEN_FONT,
  fontSize: '16px',
};

const statusChoiceRow: React.CSSProperties = {
  display: 'flex',
  flexWrap: 'wrap',
  gap: '6px',
};

const sealCell: React.CSSProperties = {
  border: `1px solid ${GOLD_FAINT}`,
  padding: '8px 4px',
  textAlign: 'center',
  background: 'rgba(255, 248, 215, 0.45)',
  minHeight: '104px',
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
  width: '54px',
  height: '54px',
  margin: '2px auto 3px',
  transform: 'rotate(-8deg)',
  filter: 'drop-shadow(0 1px 2px rgba(80, 12, 12, 0.35))',
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

const getDefectKind = (note: string): DefectKind => {
  if (note.includes('клякса')) {
    return 'ink_blot';
  }
  if (note.includes('Чернила на печати')) {
    return 'seal_ink_smudge';
  }
  if (note.includes('букв') && note.includes('имени')) {
    return 'owner_letter_wobble';
  }
  if (note.includes('Край пергамента')) {
    return 'ragged_parchment_edge';
  }
  if (note.includes('Подпись')) {
    return 'uncertain_signature';
  }
  if (note.includes('несвежим')) {
    return 'stale_parchment_smell';
  }
  if (note.includes('Лазуритный инициал')) {
    return 'lapis_initial_misaligned';
  }
  if (note.includes('Разлиновочные проколы')) {
    return 'misruled_pricking';
  }
  if (note.includes('Золочёный кант')) {
    return 'gold_edge_cut';
  }
  if (note.includes('шнур продет повторно')) {
    return 'rethreaded_cord';
  }
  if (note.includes('Сургуч')) {
    return 'reheated_wax';
  }
  if (note.includes('синеватый ореол')) {
    return 'blue_ink_halo';
  }
  if (note.includes('В дате')) {
    return 'corrected_date';
  }
  if (note.includes('Зизо') || note.includes('Граггар') || note.includes('Маттиос')) {
    return 'heretical_marginalia';
  }
  return 'generic';
};

const getDefectKinds = (notes: string[]): DefectKind[] =>
  Array.from(new Set(notes.map(getDefectKind)));

const hasDefect = (defectKinds: DefectKind[], defectKind: DefectKind) =>
  defectKinds.includes(defectKind);

const buildShellStyle = (defectKinds: DefectKind[]): React.CSSProperties =>
  defectKinds.length
    ? {
        ...shellStyle,
        outline: hasDefect(defectKinds, 'heretical_marginalia')
          ? `1px solid rgba(85, 14, 14, 0.7)`
          : `1px solid rgba(138, 26, 26, 0.45)`,
        boxShadow: `${shellStyle.boxShadow}, inset 0 0 42px rgba(138, 26, 26, 0.16)`,
      }
    : shellStyle;

const buildFieldValueStyle = (
  defectKinds: DefectKind[],
  field: 'owner' | 'status' | 'expiry',
): React.CSSProperties => {
  if (hasDefect(defectKinds, 'owner_letter_wobble') && field === 'owner') {
    return {
      ...fieldValue,
      color: '#4b1010',
      textDecoration: 'underline wavy rgba(138, 26, 26, 0.9)',
      textUnderlineOffset: '3px',
      transform: 'rotate(-0.5deg)',
    };
  }
  if (hasDefect(defectKinds, 'corrected_date') && field === 'expiry') {
    return {
      ...fieldValue,
      color: '#4b1010',
      textDecoration: 'line-through rgba(138, 26, 26, 0.75)',
      textDecorationThickness: '2px',
      transform: 'rotate(0.8deg)',
    };
  }
  return fieldValue;
};

const buildDescriptionStyle = (
  defectKinds: DefectKind[],
): React.CSSProperties => {
  let style: React.CSSProperties = descriptionStyle;

  if (hasDefect(defectKinds, 'stale_parchment_smell')) {
    style = {
      ...style,
      background: `
        radial-gradient(circle at 18% 26%, rgba(98, 65, 22, 0.16) 0 9%, transparent 15%),
        radial-gradient(circle at 76% 68%, rgba(80, 50, 18, 0.14) 0 7%, transparent 13%),
        rgba(255, 248, 215, 0.24)
      `,
      color: '#241b18',
    };
  }
  if (hasDefect(defectKinds, 'blue_ink_halo')) {
    style = {
      ...style,
      boxShadow: 'inset 0 0 26px rgba(30, 58, 138, 0.22)',
      background: `
        radial-gradient(ellipse at 46% 42%, rgba(30, 58, 138, 0.18) 0 16%, transparent 35%),
        rgba(255, 248, 215, 0.35)
      `,
    };
  }
  if (hasDefect(defectKinds, 'heretical_marginalia')) {
    style = {
      ...style,
      boxShadow: 'inset 0 0 0 2px rgba(85, 14, 14, 0.18)',
    };
  }
  return style;
};

const buildStamperLabelStyle = (
  defectKinds: DefectKind[],
): React.CSSProperties =>
  hasDefect(defectKinds, 'uncertain_signature')
    ? {
        ...sealStamperLabel,
        color: '#7d1616',
        transform: 'rotate(-2deg)',
        textDecoration: 'underline wavy rgba(138, 26, 26, 0.65)',
      }
    : sealStamperLabel;

const DefectOverlay = (props: { defectKinds: DefectKind[] }) => {
  const { defectKinds } = props;

  if (!defectKinds.length) {
    return null;
  }

  return (
    <>
      {(hasDefect(defectKinds, 'ink_blot') || hasDefect(defectKinds, 'generic')) && (
        <Box
          style={{
            position: 'absolute',
            top: '62px',
            left: '34px',
            width: '58px',
            height: '42px',
            pointerEvents: 'none',
            background: `
              radial-gradient(circle at 42% 42%, rgba(20, 20, 48, 0.58) 0 18%, transparent 34%),
              radial-gradient(circle at 66% 58%, rgba(20, 20, 48, 0.28) 0 10%, transparent 22%),
              radial-gradient(circle at 28% 70%, rgba(20, 20, 48, 0.22) 0 8%, transparent 18%)
            `,
            filter: 'blur(0.4px)',
            transform: 'rotate(-16deg)',
          }}
        />
      )}
      {hasDefect(defectKinds, 'ragged_parchment_edge') && (
        <svg
          aria-hidden="true"
          style={{
            position: 'absolute',
            right: '14px',
            top: '56px',
            width: '18px',
            height: 'calc(100% - 112px)',
            pointerEvents: 'none',
          }}
          viewBox="0 0 18 600"
          preserveAspectRatio="none"
        >
          <path
            d="M13 0 L7 38 L15 72 L5 111 L13 153 L6 196 L16 234 L7 279 L14 322 L5 366 L12 410 L6 454 L15 498 L7 548 L13 600"
            fill="none"
            stroke="rgba(138, 26, 26, 0.72)"
            strokeLinecap="round"
            strokeWidth="2.2"
          />
        </svg>
      )}
      {hasDefect(defectKinds, 'gold_edge_cut') && (
        <svg
          aria-hidden="true"
          style={{
            position: 'absolute',
            left: '24px',
            top: '26px',
            width: 'calc(100% - 48px)',
            height: '28px',
            pointerEvents: 'none',
          }}
          viewBox="0 0 700 28"
          preserveAspectRatio="none"
        >
          <path
            d="M12 17 L72 17 L86 7 L102 18 L190 18 L207 9 L223 19 L366 19 L382 8 L397 18 L520 18 L538 9 L554 19 L686 19"
            fill="none"
            stroke="rgba(124, 94, 26, 0.74)"
            strokeLinecap="round"
            strokeWidth="2.4"
          />
          <path
            d="M86 7 L92 21 M207 9 L213 22 M382 8 L389 22 M538 9 L545 22"
            fill="none"
            stroke="rgba(138, 26, 26, 0.58)"
            strokeLinecap="round"
            strokeWidth="1.5"
          />
        </svg>
      )}
      {hasDefect(defectKinds, 'lapis_initial_misaligned') && (
        <Box
          style={{
            position: 'absolute',
            top: '74px',
            left: '92px',
            width: '44px',
            height: '34px',
            pointerEvents: 'none',
            color: 'rgba(30, 58, 138, 0.68)',
            fontFamily: '"Palatino Linotype", "Times New Roman", serif',
            fontSize: '31px',
            fontWeight: 'bold',
            lineHeight: '32px',
            transform: 'rotate(-7deg)',
            textShadow: '2px 1px 0 rgba(30, 58, 138, 0.16)',
          }}
        >
          П
        </Box>
      )}
      {hasDefect(defectKinds, 'misruled_pricking') && (
        <Box
          style={{
            position: 'absolute',
            left: '72px',
            bottom: '154px',
            width: '168px',
            height: '42px',
            pointerEvents: 'none',
            transform: 'rotate(-5deg)',
          }}
        >
          <Box
            style={{
              position: 'absolute',
              left: '6px',
              right: '4px',
              top: '14px',
              borderTop: '1px solid rgba(92, 56, 20, 0.32)',
              transform: 'rotate(2deg)',
            }}
          />
          <Box
            style={{
              position: 'absolute',
              left: '14px',
              right: '0',
              top: '28px',
              borderTop: '1px solid rgba(92, 56, 20, 0.24)',
              transform: 'rotate(-1deg)',
            }}
          />
          {[0, 18, 36, 54, 72, 90, 108, 126, 144].map((left) => (
            <Box
              key={left}
              style={{
                position: 'absolute',
                left: `${left}px`,
                bottom: '0',
                width: '4px',
                height: '4px',
                borderRadius: '50%',
                background: 'rgba(92, 56, 20, 0.42)',
                boxShadow: '0 0 3px rgba(92, 56, 20, 0.18)',
              }}
            />
          ))}
        </Box>
      )}
      {hasDefect(defectKinds, 'stale_parchment_smell') && (
        <Box
          style={{
            position: 'absolute',
            inset: '22px',
            pointerEvents: 'none',
            background: `
              radial-gradient(circle at 14% 18%, rgba(76, 47, 17, 0.11) 0 5%, transparent 12%),
              radial-gradient(circle at 82% 28%, rgba(82, 48, 20, 0.1) 0 4%, transparent 10%),
              radial-gradient(circle at 38% 86%, rgba(50, 35, 18, 0.09) 0 6%, transparent 14%)
            `,
            mixBlendMode: 'multiply',
          }}
        />
      )}
      {hasDefect(defectKinds, 'rethreaded_cord') && (
        <Box
          style={{
            position: 'absolute',
            left: '50%',
            bottom: '112px',
            width: '118px',
            height: '34px',
            marginLeft: '-59px',
            pointerEvents: 'none',
            transform: 'rotate(2deg)',
          }}
        >
          <Box
            style={{
              position: 'absolute',
              left: '10px',
              top: '12px',
              width: '96px',
              borderTop: '2px dashed rgba(124, 94, 26, 0.58)',
            }}
          />
          {[18, 46, 74].map((left) => (
            <Box
              key={left}
              style={{
                position: 'absolute',
                left: `${left}px`,
                top: '6px',
                width: '12px',
                height: '12px',
                border: '2px solid rgba(92, 56, 20, 0.58)',
                borderRadius: '50%',
                boxShadow: '0 0 0 3px rgba(138, 26, 26, 0.08)',
              }}
            />
          ))}
        </Box>
      )}
      {hasDefect(defectKinds, 'heretical_marginalia') && (
        <Box
          style={{
            position: 'absolute',
            right: '38px',
            top: '158px',
            width: '132px',
            pointerEvents: 'none',
            color: 'rgba(74, 7, 7, 0.72)',
            fontFamily: HANDWRITTEN_FONT,
            fontSize: '12px',
            lineHeight: '1.35em',
            textAlign: 'center',
            transform: 'rotate(9deg)',
            textShadow: '0 0 1px rgba(74, 7, 7, 0.25)',
          }}
        >
          <Box>Зизо помнит</Box>
          <Box>Граггар взыщет</Box>
          <Box>Маттиос взвесит</Box>
        </Box>
      )}
    </>
  );
};

const isRoyalSeal = (seal: SealData) =>
  seal.label === 'Король' || seal.label === 'Герцог';

const getSealMark = (seal: SealData) => seal.label.trim().charAt(0);

const OrnateWaxSeal = (props: {
  seal: SealData;
  smudged?: boolean;
  reheated?: boolean;
}) => {
  const { seal, smudged, reheated } = props;
  const royal = isRoyalSeal(seal);

  return (
    <svg
      aria-label={`Печать: ${seal.label}`}
      role="img"
      style={{
        ...sealStamp,
        ...(smudged
          ? {
              transform: 'rotate(-14deg) skewX(-4deg)',
              filter:
                'drop-shadow(0 1px 2px rgba(80, 12, 12, 0.35)) saturate(0.85)',
            }
          : {}),
        ...(reheated
          ? {
              transform: 'rotate(-5deg) scale(1.04)',
              filter:
                'drop-shadow(0 0 4px rgba(246, 140, 55, 0.55)) brightness(1.12)',
            }
          : {}),
      }}
      viewBox="0 0 80 80"
    >
      <path
        d="M39 4 C45 2 48 8 53 8 C61 8 61 17 68 20 C75 23 70 32 74 38 C79 47 69 51 68 58 C67 67 56 64 51 72 C45 80 38 72 31 75 C22 79 20 68 13 66 C5 63 11 52 6 47 C-1 39 9 34 8 28 C7 19 18 19 22 12 C27 4 33 8 39 4 Z"
        fill="#8b1a1a"
      />
      <path
        d="M40 9 C46 7 49 12 54 13 C60 14 61 21 66 25 C70 29 66 36 69 41 C72 48 64 52 62 58 C60 65 52 63 47 68 C41 74 35 67 29 68 C21 69 20 60 15 57 C9 53 14 45 11 40 C7 33 15 29 15 23 C16 16 24 17 28 12 C32 8 36 11 40 9 Z"
        fill="#b42a24"
        opacity="0.72"
      />
      <circle cx="40" cy="40" fill="none" r="26" stroke="#f0a08a" strokeWidth="2" />
      <circle
        cx="40"
        cy="40"
        fill="none"
        opacity="0.55"
        r="20"
        stroke="#5c0c0c"
        strokeDasharray="2 3"
        strokeWidth="1.5"
      />
      <path
        d="M21 38 C27 27 33 25 40 31 C47 25 54 27 59 38"
        fill="none"
        opacity="0.65"
        stroke="#5c0c0c"
        strokeLinecap="round"
        strokeWidth="2"
      />
      <path
        d="M21 45 C28 55 35 56 40 50 C46 56 53 55 59 45"
        fill="none"
        opacity="0.65"
        stroke="#5c0c0c"
        strokeLinecap="round"
        strokeWidth="2"
      />
      {royal ? (
        <g fill="#f3c164" stroke="#5c0c0c" strokeLinejoin="round" strokeWidth="2">
          <path d="M22 48 L25 28 L34 40 L40 24 L47 40 L56 28 L59 48 Z" />
          <path d="M24 51 H58 V57 H24 Z" />
          <circle cx="25" cy="27" r="3" />
          <circle cx="40" cy="23" r="3" />
          <circle cx="56" cy="27" r="3" />
        </g>
      ) : (
        <text
          fill="#f3c164"
          fontFamily='"Palatino Linotype", "Times New Roman", serif'
          fontSize="30"
          fontWeight="700"
          stroke="#5c0c0c"
          strokeWidth="0.9"
          textAnchor="middle"
          x="40"
          y="51"
        >
          {getSealMark(seal)}
        </text>
      )}
      <path
        d="M19 22 C14 29 13 36 15 44 M61 22 C66 29 67 36 65 44 M22 61 C30 67 50 67 58 61"
        fill="none"
        opacity="0.38"
        stroke="#ffd2bc"
        strokeLinecap="round"
        strokeWidth="2"
      />
      {reheated && (
        <g opacity="0.52">
          <path
            d="M18 30 C27 18 52 18 62 31 C68 41 61 59 45 64"
            fill="none"
            stroke="#ffb15d"
            strokeLinecap="round"
            strokeWidth="4"
          />
          <circle cx="26" cy="57" fill="#ffb15d" r="3" />
          <circle cx="56" cy="23" fill="#ffd08a" r="2.5" />
        </g>
      )}
      {smudged && (
        <g opacity="0.42">
          <path
            d="M31 55 C43 61 52 59 66 62"
            fill="none"
            stroke="#5c0c0c"
            strokeLinecap="round"
            strokeWidth="5"
          />
          <path
            d="M28 49 C40 52 53 51 64 55"
            fill="none"
            stroke="#b42a24"
            strokeLinecap="round"
            strokeWidth="4"
          />
        </g>
      )}
    </svg>
  );
};

const renderSeal = (seal: SealData, defectKinds: DefectKind[]) => (
  <Box style={sealCell}>
    <Box style={sealLabel}>{seal.label}</Box>
    {seal.stamped ? (
      <>
        <OrnateWaxSeal
          seal={seal}
          smudged={hasDefect(defectKinds, 'seal_ink_smudge')}
          reheated={hasDefect(defectKinds, 'reheated_wax')}
        />
        <Box style={buildStamperLabelStyle(defectKinds)}>{seal.stamper}</Box>
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
    can_become_resident,
    can_detect,
    detection_done,
    detection_result,
    detection_note,
    defect_note,
    defect_notes,
  } = data;

  const [draftOwnerName, setDraftOwnerName] = useState(owner_name || '');
  const [draftOwnerStatus, setDraftOwnerStatus] = useState(
    owner_status || 'Безызвестное',
  );
  const isOwnerView = Boolean(is_owner);
  const isBound = Boolean(is_bound);
  const canEditFake = Boolean(can_edit_fake);
  const canBecomeResident = Boolean(can_become_resident);
  const canDetect = Boolean(can_detect);
  const detectionDone = Boolean(detection_done);
  const foundDefectNotes =
    Array.isArray(defect_notes) && defect_notes.length
      ? defect_notes.filter(Boolean)
      : defect_note
        ? [defect_note]
        : [];
  const foundDefect =
    detectionDone && detection_result === 'fake' && foundDefectNotes.length > 0;
  const defectKinds = foundDefect ? getDefectKinds(foundDefectNotes) : [];
  const visibleSeals = [
    seal_chancellor,
    seal_elder,
    seal_duke,
    seal_hand,
  ].filter((seal) => seal.visible !== false);

  useEffect(() => {
    setDraftOwnerName(owner_name || '');
    setDraftOwnerStatus(owner_status || 'Безызвестное');
  }, [owner_name, owner_status]);

  const saveFakeManuscript = () => {
    act('save_fake', {
      owner_name: draftOwnerName,
      owner_status: draftOwnerStatus,
    });
  };

  return (
    <Window
      width={760}
      height={900}
      title="Подорожная грамота"
      theme="blackstone"
    >
      <Window.Content scrollable>
        <Box style={buildShellStyle(defectKinds)}>
          <DefectOverlay defectKinds={defectKinds} />
          <Box>
            <Box style={titleStyle}>Подорожная грамота</Box>
            <Box style={subtitleStyle}>
              ~ Под Рукой Короны ~ {issued_place || '—'} ~
            </Box>
          </Box>

          <Box>
            <Box style={fieldRow}>
              <Box style={fieldLabel}>Имя</Box>
              <Box style={buildFieldValueStyle(defectKinds, 'owner')}>
                {canEditFake ? (
                  <Input
                    fluid
                    maxLength={64}
                    style={manuscriptInputStyle}
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
              <Box style={buildFieldValueStyle(defectKinds, 'status')}>
                {canEditFake ? (
                  <Box style={statusChoiceRow}>
                    {STATUS_OPTIONS.map((status) => (
                      <Button
                        key={status}
                        selected={draftOwnerStatus === status}
                        onClick={() => setDraftOwnerStatus(status)}
                      >
                        {status}
                      </Button>
                    ))}
                  </Box>
                ) : (
                  owner_status || '—'
                )}
              </Box>
            </Box>
            <Box style={fieldRow}>
              <Box style={fieldLabel}>Дана впредь до..</Box>
              <Box style={buildFieldValueStyle(defectKinds, 'expiry')}>
                {expiry_date || '—'}
              </Box>
            </Box>
          </Box>

          <Box style={buildDescriptionStyle(defectKinds)}>{description}</Box>

          <Box
            style={{
              display: 'grid',
              gridTemplateColumns: `repeat(${Math.max(visibleSeals.length, 1)}, 1fr)`,
              gap: '8px',
            }}
          >
            {visibleSeals.map((seal) => (
              <Box key={seal.label}>{renderSeal(seal, defectKinds)}</Box>
            ))}
          </Box>

          <Divider />

          <Stack align="center">
            <Stack.Item grow>
              <Box style={footerBox}>
                {isBound
                  ? isOwnerView
                    ? 'Грамота признана вашей.'
                    : 'Грамота принадлежит иному.'
                  : 'Грамота ещё не скреплена с ликом владельца.'}
              </Box>
              {foundDefectNotes.length > 0 && (
                <Box style={defectNote}>
                  {foundDefectNotes.map((note) => (
                    <Box key={note}>• {note}</Box>
                  ))}
                </Box>
              )}
              {detectionDone && (
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
              {canEditFake && (
                <Button
                  icon="save"
                  color="good"
                  onClick={saveFakeManuscript}
                  tooltip="Сохранить заполненную подделку"
                >
                  Сохранить
                </Button>
              )}
              {canDetect && (
                <Button
                  icon="search"
                  onClick={() => act('detect')}
                  tooltip="Тайно изучить грамоту на предмет подделки"
                >
                  Изучить
                </Button>
              )}
              {canBecomeResident && (
                <Button
                  icon="scroll"
                  color="good"
                  onClick={() => act('become_resident')}
                  tooltip="Признать грамоту основанием для гражданства"
                >
                  Стать гражданином
                </Button>
              )}
              {!isBound && !canEditFake && (
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
