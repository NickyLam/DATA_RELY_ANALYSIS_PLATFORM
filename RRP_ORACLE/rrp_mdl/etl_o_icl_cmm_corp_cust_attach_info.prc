CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_CORP_CUST_ATTACH_INFO(I_P_DATE IN INTEGER,
                                                                O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_CORP_CUST_ATTACH_INFO
  *  功能描述：对公客户补充信息，将数据从视图落地
  *  创建日期：20230215
  *  开发人员：梅炜
  *  来源表：  ICL.V_CMM_CORP_CUST_ATTACH_INFO
  *  目标表：  O_ICL_CMM_CORP_CUST_ATTACH_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230215  梅炜      首次创建
                2    20230215  梅炜      修改参数
                3    20240829  YJY       新增国家技术创新示范企业标志、制造业单项冠军企业标志
                4    20250303  YJY       新增创新型中小企业标志、科技型中小企业标志、国家企业技术中心标志、各类科技名单企业标志
                5    20250819  YJY       新增投资级客户标志
                6    20251114  YJY       新增基本开户行行号
                7    20260317  YJY       新增退役军人创办企业标志
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_CORP_CUST_ATTACH_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_CORP_CUST_ATTACH_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--普通表的重跑处理
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_CORP_CUST_ATTACH_INFO';--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-对公客户补充信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_CUST_ATTACH_INFO
    (ETL_DT                                   --数据日期
    ,LP_ID                                    --法人编号
    ,CUST_ID                                  --客户编号
    ,CUST_TYPE_CD                             --客户类型代码
    ,CUST_NAME                                --客户名称
    ,ADV_MAN_INDU_FLG                         --先进制造业标志
    ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG      --专精特新中小企业标志
    ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG        --专精特新小巨人企业标志
    ,HIGH_NEW_TECH_CORP_FLG                   --高新技术企业标志
    ,OPEN_ACCT_LICS_ID                        --开户许可证编号
    ,OPEN_ACCT_LICS_APPRV_DT                  --开户许可证核准日期
    ,JOB_CD                                   --任务代码
    --,ETL_TIMESTAMP                          --数据处理时间
    ,AGRI_PROPERTY_LEAD_ENTERP_FLG            --农业产业化龙头企业标志
    ,FARM_AND_NEW_AGRI_MANG_MAIN_LOAN_FLG     --农户及新型农业经营主体贷款标志
    ,RISK_DIST_CD                             --客户风险行政区划代码
    ,LEI_ID                                   --LEI编号
    ,CTY_TECH_INOVT_CORP_FLG                  --国家技术创新示范企业标志  ADD BY YJY 20240829
    ,ITEM_CORP_FLG                            --制造业单项冠军企业标志  ADD BY YJY 20240829
    ,INOVT_MED_SIDE_ENTER_FLG                 --创新型中小企业标志  ADD BY YJY 20250303
    ,SCEN_TECH_MED_SIDE_ENTER_FLG             --科技型中小企业标志  ADD BY YJY 20250303 
    ,CTY_CORP_TECH_CENTER_FLG                 --国家企业技术中心标志 ADD BY YJY 20250303
    ,EACH_CLASS_SCEN_TECH_LIST_CORP_FLG       --各类科技名单企业标志 ADD BY YJY 20250303
    ,INVEST_CUST_FLG                          --投资级客户标志 ADD BY YJY 20250819
    ,BASIC_OPEN_BANK_NO                       --基本开户行行号  ADD BY YJY 20251114
    ,EX_SERVISMAN_CORP_FLG                    --退役军人创办企业标志  ADD BY YJY 20260317
    )
  SELECT ETL_DT                                    --数据日期
        ,LP_ID                                    --法人编号
        ,CUST_ID                                  --客户编号
        ,CUST_TYPE_CD                             --客户类型代码
        ,CUST_NAME                                --客户名称
        ,ADV_MAN_INDU_FLG                         --先进制造业标志
        ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG      --专精特新中小企业标志
        ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG        --专精特新小巨人企业标志
        ,HIGH_NEW_TECH_CORP_FLG                   --高新技术企业标志
        ,OPEN_ACCT_LICS_ID                        --开户许可证编号
        ,OPEN_ACCT_LICS_APPRV_DT                  --开户许可证核准日期
        ,JOB_CD                                   --任务代码
        --,ETL_TIMESTAMP                          --数据处理时间
        ,AGRI_PROPERTY_LEAD_ENTERP_FLG            --农业产业化龙头企业标志
        ,FARM_AND_NEW_AGRI_MANG_MAIN_LOAN_FLG     --农户及新型农业经营主体贷款标志
        ,RISK_DIST_CD                             --客户风险行政区划代码
        ,LEI_ID                                   --LEI编号
        ,CTY_TECH_INOVT_CORP_FLG                  --国家技术创新示范企业标志  ADD BY YJY 20240829
        ,ITEM_CORP_FLG                            --制造业单项冠军企业标志  ADD BY YJY 20240829
        ,INOVT_MED_SIDE_ENTER_FLG                 --创新型中小企业标志  ADD BY YJY 20250303
        ,SCEN_TECH_MED_SIDE_ENTER_FLG             --科技型中小企业标志  ADD BY YJY 20250303 
        ,CTY_CORP_TECH_CENTER_FLG                 --国家企业技术中心标志 ADD BY YJY 20250303
        ,EACH_CLASS_SCEN_TECH_LIST_CORP_FLG       --各类科技名单企业标志 ADD BY YJY 20250303
        ,INVEST_CUST_FLG                          --投资级客户标志 ADD BY YJY 20250819
        ,BASIC_OPEN_BANK_NO                       --基本开户行行号  ADD BY YJY 20251114
        ,EX_SERVISMAN_CORP_FLG                    --退役军人创办企业标志  ADD BY YJY 20260317
    FROM ICL.V_CMM_CORP_CUST_ATTACH_INFO   --视图-对公客户补充信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_CORP_CUST_ATTACH_INFO', '', O_ERRCODE);

  V_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 -- ';
  V_STARTTIME := SYSDATE;
  --插入跑批完成记录--
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_ICL_CMM_CORP_CUST_ATTACH_INFO;
/

