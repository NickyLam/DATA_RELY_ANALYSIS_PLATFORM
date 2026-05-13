CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_UXDS_SEC_BASIC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：a股基本资料
  **存储过程名称：    ETL_O_IOL_UXDS_SEC_BASIC_INFO
  **存储过程创建日期：20251209
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251209    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_UXDS_SEC_BASIC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_UXDS_SEC_BASIC_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-a股基本资料';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_UXDS_SEC_BASIC_INFO NOLOGGING 
  (    SEQ                   --记录唯一标识
      ,CTIME                 --记录创建时间
      ,MTIME                 --记录修改时间
      ,RTIME                 --记录通讯到用户端时间
      ,SEC_ISSUER_ID         --证券发行主体id
      ,SEC_CODE              --证券代码
      ,SEC_SHORT_NAME_CN     --证券简称(中文)
      ,PHONETIC_SHORT_NAME   --拼音简称
      ,SEC_FULL_NAME         --证券全称
      ,SEC_TYPE_CODE         --证券类别编码@关联到sec_classi_public_code_table.ctgry_code
      ,SEC_TYPE              --证券类别@阳光私募
      ,TD_MKT_ENCODE         --交易市场编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=212
      ,TD_MKT                --交易市场
      ,LISTED_DATE           --上市日期
      ,STOP_LISTING_DATE     --终止上市日期
      ,ISSUE_ORG_ID          --发行机构id@关联到corp_basic_info.org_id
      ,LISTED_STATUS_CODE    --上市状态编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=213
      ,LISTED_STATUS         --上市状态@包括：正常上市、终止上市、暂停上市、ST、*ST、已发行未上市等
      ,THSCODE               --同花顺代码
      ,SEC_ID                --证券id
      ,IS_LISTING            --是否上市@0：否；1：是
      ,IS_DELISTED           --是否摘牌@0：否；1：是
      ,LISTED_BOARD_CODE     --上市板编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=216
      ,LISTED_BOARD_NAME     --上市板名称
      ,TD_CURRENCY_CODE      --交易货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518
      ,TD_CURRENCY_NAME      --交易货币名称
      ,ISIN                  --全球证券分类识别码
      ,CUSIP                 --美国统一证券识别编码
      ,SEC_FULL_NAME_EN      --证券英文全称
      ,SEC_SHORT_NAME_EN     --证券简称(英文)
      ,ISVALID               --是否有效
      ,ETL_DT                --ETL处理日期
      ,ETL_TIMESTAMP         --ETL处理时间戳
    )
  SELECT 
       SEQ                   --记录唯一标识
      ,CTIME                 --记录创建时间
      ,MTIME                 --记录修改时间
      ,RTIME                 --记录通讯到用户端时间
      ,SEC_ISSUER_ID         --证券发行主体id
      ,SEC_CODE              --证券代码
      ,SEC_SHORT_NAME_CN     --证券简称(中文)
      ,PHONETIC_SHORT_NAME   --拼音简称
      ,SEC_FULL_NAME         --证券全称
      ,SEC_TYPE_CODE         --证券类别编码@关联到sec_classi_public_code_table.ctgry_code
      ,SEC_TYPE              --证券类别@阳光私募
      ,TD_MKT_ENCODE         --交易市场编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=212
      ,TD_MKT                --交易市场
      ,LISTED_DATE           --上市日期
      ,STOP_LISTING_DATE     --终止上市日期
      ,ISSUE_ORG_ID          --发行机构id@关联到corp_basic_info.org_id
      ,LISTED_STATUS_CODE    --上市状态编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=213
      ,LISTED_STATUS         --上市状态@包括：正常上市、终止上市、暂停上市、ST、*ST、已发行未上市等
      ,THSCODE               --同花顺代码
      ,SEC_ID                --证券id
      ,IS_LISTING            --是否上市@0：否；1：是
      ,IS_DELISTED           --是否摘牌@0：否；1：是
      ,LISTED_BOARD_CODE     --上市板编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=216
      ,LISTED_BOARD_NAME     --上市板名称
      ,TD_CURRENCY_CODE      --交易货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518
      ,TD_CURRENCY_NAME      --交易货币名称
      ,ISIN                  --全球证券分类识别码
      ,CUSIP                 --美国统一证券识别编码
      ,SEC_FULL_NAME_EN      --证券英文全称
      ,SEC_SHORT_NAME_EN     --证券简称(英文)
      ,ISVALID               --是否有效
      ,ETL_DT                --ETL处理日期
      ,ETL_TIMESTAMP         --ETL处理时间戳
    FROM IOL.V_UXDS_SEC_BASIC_INFO --视图-a股基本资料
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_UXDS_SEC_BASIC_INFO', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_UXDS_SEC_BASIC_INFO;
/

