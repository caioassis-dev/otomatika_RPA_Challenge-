*** Settings ***
Library  RPA.Browser.Selenium
Library  RPA.Tables
Library  RPA.Excel.Files
Library  RPA.HTTP
Library  RPA.Robocloud.Items
Variables  variables.py
Resource  keywords.robot

*** Variables ***
${URL}  https://www.reuters.com/
${SEARCH_PHRASE}  ${search_phrase}
${CATEGORY}  ${category}
${MONTHS}  ${months}

*** Tasks ***
Extract News Data
    Open Browser    ${URL}  headless=False
    Input Search Phrase  ${SEARCH_PHRASE}
    Select News Category  ${CATEGORY}
    Extract News Info
    Close Browser