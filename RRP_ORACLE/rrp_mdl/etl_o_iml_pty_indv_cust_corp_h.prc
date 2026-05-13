CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PTY_INDV_CUST_CORP_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：个人客户经营实体历史
  **存储过程名称：    ETL_O_IML_PTY_INDV_CUST_CORP_H
  **存储过程创建日期：20250623
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250623    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_PTY_INDV_CUST_CORP_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PTY_INDV_CUST_CORP_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-个人客户经营实体历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_PTY_INDV_CUST_CORP_H NOLOGGING 
  (         CUST_ID             --客户编号
           ,LP_ID               --法人编号
           ,CUST_NAME           --客户名称
           ,CERT_TYPE_CD        --证件类型代码
           ,CERT_NO             --证件号码
           ,CUST_CORP_RELA_CD   --借款人与企业关系代码
           ,CORP_CUST_ID        --企业客户编号
           ,CORP_NAME           --企业名称
           ,CORP_CERT_TYPE_CD   --企业证件类型代码
           ,CORP_CERT_NO        --企业证件号码
           ,CORP_CERT_EXP_DT    --企业证件到期日期
           ,CORP_MANG_ADDR      --企业经营地址
           ,CORP_FOUND_DT       --企业成立日期
           ,CORP_SIZE_CD        --企业规模代码
           ,LEGAL_REP_NAME      --法定代表人
           ,EMPLY_NUMBER        --职工人数
           ,BUS_ANL_INCO        --营业年收入
           ,TOT_ASSET           --总资产
           ,BL_INDUTY_TYPE_CD   --所属行业类型代码
           ,BL_INDUTY_NAME      --所属行业名称
           ,CREATE_TELLER_ID    --创建柜员编号
           ,CREATE_ORG_ID       --创建机构编号
           ,INIT_CREATE_DT      --最初创建日期
           ,UPDATE_TELLER_ID    --更新柜员编号
           ,UPDATE_ORG_ID       --更新机构编号
           ,UPDATE_CHN_ID       --更新渠道编号
           ,UPDATE_SYS_NAME     --更新系统名称
           ,LATEST_UPDATE_DT    --最新更新日期
           ,SORC_SYS_NAME       --源系统名称
           ,SORC_SYS_CHN_ID     --源系统渠道编号
           ,SORC_SYS_CREATE_DT  --源系统创建日期
           ,START_DT            --开始时间
           ,END_DT              --结束时间
           ,ID_MARK             --增删标志
           ,SRC_TABLE_NAME      --源表名称
           ,JOB_CD              --任务编码
           ,ETL_TIMESTAMP       --ETL处理时间戳
    )
    SELECT
            CUST_ID             --客户编号
           ,LP_ID               --法人编号
           ,CUST_NAME           --客户名称
           ,CERT_TYPE_CD        --证件类型代码
           ,CERT_NO             --证件号码
           ,CUST_CORP_RELA_CD   --借款人与企业关系代码
           ,CORP_CUST_ID        --企业客户编号
           ,CORP_NAME           --企业名称
           ,CORP_CERT_TYPE_CD   --企业证件类型代码
           ,CORP_CERT_NO        --企业证件号码
           ,CORP_CERT_EXP_DT    --企业证件到期日期
           ,CORP_MANG_ADDR      --企业经营地址
           ,CORP_FOUND_DT       --企业成立日期
           ,CORP_SIZE_CD        --企业规模代码
           ,LEGAL_REP_NAME      --法定代表人
           ,EMPLY_NUMBER        --职工人数
           ,BUS_ANL_INCO        --营业年收入
           ,TOT_ASSET           --总资产
           ,BL_INDUTY_TYPE_CD   --所属行业类型代码
           ,BL_INDUTY_NAME      --所属行业名称
           ,CREATE_TELLER_ID    --创建柜员编号
           ,CREATE_ORG_ID       --创建机构编号
           ,INIT_CREATE_DT      --最初创建日期
           ,UPDATE_TELLER_ID    --更新柜员编号
           ,UPDATE_ORG_ID       --更新机构编号
           ,UPDATE_CHN_ID       --更新渠道编号
           ,UPDATE_SYS_NAME     --更新系统名称
           ,LATEST_UPDATE_DT    --最新更新日期
           ,SORC_SYS_NAME       --源系统名称
           ,SORC_SYS_CHN_ID     --源系统渠道编号
           ,SORC_SYS_CREATE_DT  --源系统创建日期
           ,START_DT            --开始时间
           ,END_DT              --结束时间
           ,ID_MARK             --增删标志
           ,SRC_TABLE_NAME      --源表名称
           ,JOB_CD              --任务编码
           ,ETL_TIMESTAMP       --ETL处理时间戳
  FROM IML.V_PTY_INDV_CUST_CORP_H --视图-个人客户经营实体历史
 WHERE ID_MARK <> 'D'
   AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') 
   ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_PTY_INDV_CUST_CORP_H', '', O_ERRCODE);

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

END ETL_O_IML_PTY_INDV_CUST_CORP_H;
/

