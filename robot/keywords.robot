*** Settings ***
Library  resources/browser.py

*** Keywords ***
Input Search Phrase
    [Arguments]  ${search_phrase}
    Input Text  css:#search-input-field  ${search_phrase}
    Press Keys  css:#search-input-field  ENTER
    Wait Until Page Contains Element  css:.search-result-indicator

Select News Category
    [Arguments]  ${category}
    # Adicione lógica para selecionar a categoria se necessário

Extract News Info
    @{articles}  Create List
    ${articles}  Run Keyword And Return Status  Get News Articles
    FOR  ${article}  IN  @{articles}
        Append To List  ${article}  @{article}
    Create Excel File With Articles  ${articles}

Create Excel File With Articles
    [Arguments]  ${articles}
    Create Workbook  output/news.xlsx
    FOR  ${article}  IN  @{articles}
        ${title}  ${date}  ${description}  ${image_filename}  ${search_phrase_count}  ${contains_money} =  ${article}
        Append Rows To Worksheet  output/news.xlsx  Sheet1  ${title}  ${date}  ${description}  ${image_filename}  ${search_phrase_count}  ${contains_money}
    Save Workbook