import { Flex, Text, Button, Grid, Box } from '@radix-ui/themes'

export default function App() {

  return (
    <Flex direction='row' gap='2' width='100%'>
      <Grid columns='6' gap='2' rows='repeat(2, 64px)' width='auto' style={{ width: '50%' }}>
        <Button />
        <Button />
        <Button />
        <Button />
        <Button />
        <Button />
      </Grid>
      <Box width='50%'>
        <Text>
          yo!
        </Text>
      </Box>
    </Flex>
  )
}
