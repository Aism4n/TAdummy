import { Box, NoticeBox, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type FamilyDisplayEntry = {
  name: string;
  label?: string | null;
  details?: string[];
  accentColor?: string | null;
};

type FamilyDisplaySection = {
  title: string;
  entries: FamilyDisplayEntry[];
};

type FamilyDisplayData = {
  title: string;
  subtitle?: string;
  emptyMessage?: string;
  sections: FamilyDisplaySection[];
};

const FamilyEntry = ({ entry }: { entry: FamilyDisplayEntry }) => {
  const accentColor = entry.accentColor || '#9370DB';
  const details = entry.details || [];

  return (
    <Box mb={1.5}>
      <Box
        style={{
          color: accentColor,
          fontWeight: 700,
          textShadow: '0 0 10px #8d5958, 0 0 20px #8d5958',
        }}>
        {entry.name}
      </Box>
      {!!entry.label && (
        <Box
          style={{
            color: '#f4e9d3',
            fontSize: '12px',
            fontWeight: 700,
            letterSpacing: '0.04em',
          }}>
          {entry.label}
        </Box>
      )}
      {!!details.length && (
        <Box style={{ color: '#c9b99b', fontSize: '12px' }}>
          {details.join(', ')}
        </Box>
      )}
    </Box>
  );
};

export const FamilyDisplayPanel = () => {
  const { data } = useBackend<FamilyDisplayData>();
  const {
    title = 'Family',
    subtitle = '',
    emptyMessage = 'Nothing to show.',
    sections = [],
  } = data;

  return (
    <Window title={title} width={720} height={580}>
      <Window.Content scrollable>
        <Stack vertical fill>
          {!!subtitle && (
            <Stack.Item>
              <NoticeBox info>{subtitle}</NoticeBox>
            </Stack.Item>
          )}
          {!sections.length && (
            <Stack.Item>
              <NoticeBox>{emptyMessage}</NoticeBox>
            </Stack.Item>
          )}
          {sections.map((section) => (
            <Stack.Item key={section.title}>
              <Section
                title={section.title}
                fill>
                {!section.entries.length && (
                  <NoticeBox>{emptyMessage}</NoticeBox>
                )}
                {section.entries.map((entry, index) => (
                  <FamilyEntry
                    key={`${section.title}-${entry.name}-${index}`}
                    entry={entry}
                  />
                ))}
              </Section>
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};
