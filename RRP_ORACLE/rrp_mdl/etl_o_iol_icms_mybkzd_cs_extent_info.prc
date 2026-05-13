CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO(I_P_DATE IN INTEGER,
                                                                         O_ERRCODE OUT VARCHAR2
                                                                         )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO
  *  功能描述：网商贷助贷初审扩展信息
  *  创建日期：20241105
  *  开发人员：YJY
  *  来源表： IOL.V_ICMS_MYBKZD_CS_EXTENT_INFO  数仓每天增量提供，凌晨1点起批，数据日期为T-1 
  *  目标表： O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20241105  YJY      首次创建
  *********************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-网商贷助贷初审扩展信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO
    (
       SERIALNO                        --流水号                 
      ,APPLYNO                         --蚂蚁申请编号           
      ,MOBILE                          --手机号码               
      ,ADDRESS                         --地址信息               
      ,PROV                            --省份                   
      ,CITY                            --城市                   
      ,AREA                            --地区                   
      ,CERTVALIDENDDATE                --证件有效期             
      ,BUSDATAREQDATE                  --采集时间               
      ,BUSINFOEXISTFLAG                --是否存有效商信息       
      ,NOTEXISTREASON                  --无有效工商信息原因     
      ,COMPANYINFONAME                 --公司名                 
      ,COMPANYINFOLAWER                --法定代表               
      ,REGISTERNO                      --工商注册号             
      ,REGISTERDATE                    --注册时间               
      ,REGISTERADDRESS                 --注册地址               
      ,REGISTERADDRESSAREACODE         --注册地址行政区编号     
      ,REGISTERADDRESSAREA             --注册地省市区           
      ,REGISTERFUND                    --注册资本(万元)         
      ,FUNDCURRENCY                    --币种                   
      ,TRADECODE                       --行业代码               
      ,MANAGERANGE                     --经营范围               
      ,ORGCODE                         --组织机构号             
      ,REGISTERDEPARTMENT              --注册工商局             
      ,STATUSID                        --经营状态               
      ,STATUSDESC                      --经营状态描述           
      ,LASTCHECKYEAR                   --最后年检年度           
      ,MANAGEBEGINDATE                 --经营开始时间           
      ,MANAGEENDDATE                   --经营结束时间           
      ,OPENDATE                        --开业时间               
      ,COMPANYTYPE                     --公司类型               
      ,ECONOMICTYPE                    --公司经济类型           
      ,TARGETJYFLAG1                   --客群经营标签（经营场景)
      ,INDUSTRYNAME                    --客群主营行业           
      ,CERTVALIDSTARTDATE              --证件有效期起始日       
      ,SEX                             --性别                   
      ,INDIVOCC                        --职业                   
      ,NATIONALITY                     --国籍                   
      ,BUSINESSSCENE                   --业务场景               
      ,BUSINESSTAG                     --业务标识               
      ,PUSHREASON                      --客群区分标识           
      ,CUSTVERIFYTYPE                  --核身方式               
      ,CUSTVERIFYRESULT                --核身结果               
      ,CUSTVERIFYTIME                  --核身通过时间           
      ,CUSTOMERTAG                     --客群标                 
      ,EMPLOYEE_ID                     --推广者员工号           
      ,NATION                          --民族                   
      ,COMPANY_INFO_ORG_CODE           --统一社会信用代码       
      ,START_DT                        --开始时间               
      ,END_DT                          --结束时间               
      ,ID_MARK                         --增删标志               
      ,ETL_TIMESTAMP                   --ETL处理时间戳                     
    )
  SELECT  
       SERIALNO                        --流水号             
      ,APPLYNO                         --蚂蚁申请编号       
      ,MOBILE                          --手机号码           
      ,ADDRESS                         --地址信息           
      ,PROV                            --省份               
      ,CITY                            --城市               
      ,AREA                            --地区               
      ,CERTVALIDENDDATE                --证件有效期         
      ,BUSDATAREQDATE                  --采集时间           
      ,BUSINFOEXISTFLAG                --是否存有效商信息   
      ,NOTEXISTREASON                  --无有效工商信息原因 
      ,COMPANYINFONAME                 --公司名             
      ,COMPANYINFOLAWER                --法定代表           
      ,REGISTERNO                      --工商注册号         
      ,REGISTERDATE                    --注册时间           
      ,REGISTERADDRESS                 --注册地址           
      ,REGISTERADDRESSAREACODE         --注册地址行政区编号 
      ,REGISTERADDRESSAREA             --注册地省市区       
      ,REGISTERFUND                    --注册资本(万元)     
      ,FUNDCURRENCY                    --币种               
      ,TRADECODE                       --行业代码           
      ,MANAGERANGE                     --经营范围           
      ,ORGCODE                         --组织机构号         
      ,REGISTERDEPARTMENT              --注册工商局         
      ,STATUSID                        --经营状态           
      ,STATUSDESC                      --经营状态描述       
      ,LASTCHECKYEAR                   --最后年检年度       
      ,MANAGEBEGINDATE                 --经营开始时间       
      ,MANAGEENDDATE                   --经营结束时间       
      ,OPENDATE                        --开业时间           
      ,COMPANYTYPE                     --公司类型           
      ,ECONOMICTYPE                    --公司经济类型       
      ,TARGETJYFLAG1                   --客群经营标签（经营?
      ,INDUSTRYNAME                    --客群主营行业       
      ,CERTVALIDSTARTDATE              --证件有效期起始日   
      ,SEX                             --性别               
      ,INDIVOCC                        --职业               
      ,NATIONALITY                     --国籍               
      ,BUSINESSSCENE                   --业务场景           
      ,BUSINESSTAG                     --业务标识           
      ,PUSHREASON                      --客群区分标识       
      ,CUSTVERIFYTYPE                  --核身方式           
      ,CUSTVERIFYRESULT                --核身结果           
      ,CUSTVERIFYTIME                  --核身通过时间       
      ,CUSTOMERTAG                     --客群标             
      ,EMPLOYEE_ID                     --推广者员工号       
      ,NATION                          --民族               
      ,COMPANY_INFO_ORG_CODE           --统一社会信用代码   
      ,START_DT                        --开始时间           
      ,END_DT                          --结束时间           
      ,ID_MARK                         --增删标志           
      ,ETL_TIMESTAMP                   --ETL处理时间戳                 
    FROM IOL.V_ICMS_MYBKZD_CS_EXTENT_INFO 
    WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      AND ID_MARK <> 'D' ;   --视图-网商贷助贷初审扩展信息


  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO;
/

