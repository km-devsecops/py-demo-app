import React from 'react';
import styled from 'styled-components';
import BgPatternDesktop from "images/bg-pattern-desktop.svg";
import IllustrationBoxDesktop from "images/illustration-box-desktop.svg";
import Culture from "images/culture.svg";
import Automation from 'images/automation.svg'
import Lean from 'images/lean.png'
import Measure from 'images/measure.jpeg'
import Security from 'images/security.jpeg'
import { softBlue, softViolet } from 'utils/variables';
import CultureList from 'components/principles/Culture';
import AutomationList from 'components/principles/Automation';
import LeanList from 'components/principles/Lean';
import MeasureList from 'components/principles/Measure';
import SharingList from 'components/principles/Sharing';


const HeaderSection = styled.div`
  height: 5vh;
  background: black;
  color: white;
  padding: 5%;
  font-size: 1.6em;
  width: 100%;
  align: Left;
  `

const TableApp = styled.div`
  border-spacing: 30px;
  padding: 5%;
  width: 90%;
  align: center;
  `
const TableCell = styled.td`
  vertical-align: top;
  `

const StyledApp = styled.div`
  height: 100vh;
  position: relative;
  background: linear-gradient(${softViolet}, ${softBlue});
  `
const StyledAccordionWrapper = styled.div`
  position: relative;
  overflow: hidden;
  display: flex;
  justify-content: flex-end;
  background-color: white;
  padding: 10px;
  border-radius: 10px;
  width: 400px;
  height: 200px;

  &:before { 
    content: "";
    position: absolute;
    width: 200%;
    height: 200%;
    top: -50%;
    left: -50%;   
    z-index: 1;
    
    background: url(${BgPatternDesktop});
    background-repeat: no-repeat;
    transform: translate(-195px,-50px);
  } 

  .cell {
    vertical-align: top;
  }

  .illustration {
    position: absolute;
    z-index: 1;
    /* left: -50px; */
    width: 50%;
    transform: translate(-50%, -50%);
    top: 50%;
    left: 17%;

    img {
      /* width: 250px; */
      /* height: 300px; */
      object-fit: cover;
      width: 100%;
    }
  }
`

const App = () => {
  return (
    <StyledApp className="App">
<HeaderSection>
<h1>DevSecOps - Proactive, Shift-Left </h1>
</HeaderSection>
<hr/>
        <TableApp>
        <tr>
        <TableCell>
            <StyledAccordionWrapper className="accordionWrapper">
              <div className="illustration">
                <img src={Culture} alt="Culture" />
              </div>
               <CultureList />
            </StyledAccordionWrapper>
        </TableCell>
        <TableCell>
            <StyledAccordionWrapper className="accordionWrapper">
              <div className="illustration">
                <img src={Automation} alt="Automation" />
              </div>
               <AutomationList />
            </StyledAccordionWrapper>
        </TableCell>

        <TableCell>
        <StyledAccordionWrapper className="accordionWrapper">
          <div className="illustration">
            <img src={Lean} alt="Lean" />
          </div>
           <LeanList />
        </StyledAccordionWrapper>
        </TableCell>
        </tr>

        <tr>
        <TableCell>
            <StyledAccordionWrapper className="accordionWrapper">
              <div className="illustration">
                <img src={Measure} alt="Measure" />
              </div>
               <MeasureList />
            </StyledAccordionWrapper>
        </TableCell>

        <TableCell>
            <StyledAccordionWrapper className="accordionWrapper">
              <div className="illustration">
                <img src={Security} alt="Security" />
              </div>
               <SharingList />
            </StyledAccordionWrapper>
        </TableCell>

        <TableCell>&nbsp;</TableCell>
        </tr>
        </TableApp>

    </StyledApp>
  );
}

export default App;
