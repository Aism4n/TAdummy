import { Box, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  owner_name: string;
  issued_place: string;
  is_resident: boolean;
};

const PARCHMENT_BG = '#f3e6c4';
const PARCHMENT_DARK = '#e6d2a1';
const INK = '#3c2a12';
const INK_FAINT = '#6b4a21';
const SEAL_RED = '#8a1a1a';

const parchmentShell: React.CSSProperties = {
  width: '100%',
  height: '100%',
  padding: '14px',
  background: `radial-gradient(ellipse at center, ${PARCHMENT_BG} 0%, ${PARCHMENT_DARK} 100%)`,
  borderRadius: '4px',
  boxShadow:
    'inset 0 0 40px rgba(90, 60, 20, 0.35), inset 0 0 4px rgba(60, 40, 10, 0.6)',
  color: INK,
  fontFamily: '"Times New Roman", Times, serif',
  display: 'flex',
  flexDirection: 'column',
};

const frameBorder: React.CSSProperties = {
  flex: 1,
  border: `2px double ${INK_FAINT}`,
  padding: '18px 22px',
  display: 'flex',
  flexDirection: 'column',
  position: 'relative',
};

const title: React.CSSProperties = {
  textAlign: 'center',
  fontSize: '22px',
  letterSpacing: '2px',
  fontVariant: 'small-caps',
  fontWeight: 'bold',
  marginBottom: '4px',
  color: INK,
};

const subtitle: React.CSSProperties = {
  textAlign: 'center',
  fontSize: '11px',
  letterSpacing: '4px',
  fontVariant: 'small-caps',
  color: INK_FAINT,
  marginBottom: '16px',
};

const divider: React.CSSProperties = {
  height: '1px',
  background: `linear-gradient(to right, transparent, ${INK_FAINT}, transparent)`,
  margin: '8px 0',
};

const bodyText: React.CSSProperties = {
  textAlign: 'center',
  fontSize: '13px',
  lineHeight: '1.7em',
  marginTop: '10px',
};

const ownerLine: React.CSSProperties = {
  textAlign: 'center',
  marginTop: '14px',
  marginBottom: '6px',
  fontSize: '26px',
  fontFamily: '"Lucida Handwriting", "Apple Chancery", cursive',
  color: INK,
  letterSpacing: '1px',
};

const ownerUnderline: React.CSSProperties = {
  width: '70%',
  margin: '0 auto 16px',
  borderBottom: `1px solid ${INK_FAINT}`,
};

const placeLine: React.CSSProperties = {
  textAlign: 'center',
  fontSize: '14px',
  fontVariant: 'small-caps',
  letterSpacing: '2px',
  marginTop: '12px',
  color: INK,
};

const seal: React.CSSProperties = {
  width: '78px',
  height: '78px',
  borderRadius: '50%',
  margin: '14px auto 0',
  border: `3px double ${SEAL_RED}`,
  color: SEAL_RED,
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  fontVariant: 'small-caps',
  fontSize: '10px',
  letterSpacing: '1px',
  textAlign: 'center',
  fontWeight: 'bold',
  transform: 'rotate(-6deg)',
  boxShadow: `inset 0 0 10px ${SEAL_RED}`,
  opacity: 0.85,
};

const footer: React.CSSProperties = {
  textAlign: 'center',
  fontSize: '10px',
  fontStyle: 'italic',
  color: INK_FAINT,
  marginTop: '10px',
};

export const ResidentManuscript = (props) => {
  const { data } = useBackend<Data>();
  const { owner_name, issued_place, is_resident } = data;

  return (
    <Window width={420} height={520} title="Resident Manuscript">
      <Window.Content fitted>
        <Box style={parchmentShell}>
          <Box style={frameBorder}>
            <Stack vertical fill>
              <Stack.Item>
                <Box style={title}>Deed of Citizenship</Box>
                <Box style={subtitle}>— By the Leave of the Crown —</Box>
                <Box style={divider} />
              </Stack.Item>

              <Stack.Item grow>
                <Box style={bodyText}>
                  Let it be known to all who read these words that the bearer
                  of this manuscript has been recognized a rightful Resident
                  of the city, afforded the honours, rights, and hearthstead
                  owed to such standing.
                </Box>

                <Box style={ownerLine}>{owner_name}</Box>
                <Box style={ownerUnderline} />

                <Box style={placeLine}>— {issued_place} —</Box>

                <Box style={seal}>
                  Sealed
                  <br />
                  &amp;
                  <br />
                  Signed
                </Box>
              </Stack.Item>

              <Stack.Item>
                <Box style={divider} />
                <Box style={footer}>
                  {is_resident
                    ? 'Witnessed under lawful hand, true and binding.'
                    : 'This deed remains unclaimed.'}
                </Box>
              </Stack.Item>
            </Stack>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};
