CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_DILG_QUOT_CTR_NT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_DILG_QUOT_CTR_NT
  *  功能描述：对话报价成交单
  *  创建日期：20251105
  *  开发人员：于敬艺
  *  来源表： IML.V_AGT_DILG_QUOT_CTR_NT
  *  目标表： O_IML_AGT_DILG_QUOT_CTR_NT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251105  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_DILG_QUOT_CTR_NT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_DILG_QUOT_CTR_NT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对话报价成交单';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_DILG_QUOT_CTR_NT NOLOGGING
    (   AGT_ID              --协议编号
       ,LP_ID               --法人编号
       ,CTR_NT_TAB_ID       --成交单表编号
       ,BATCH_ID            --批次编号
       ,CTR_NT_ID           --成交单编号
       ,TRAN_DIR_CD         --交易方向代码
       ,BUS_TYPE_CD         --业务类型代码
       ,BILL_TYPE_CD        --票据类型代码
       ,BILL_MED_CD         --票据介质代码
       ,BAG_WAY_CD          --成交方式代码
       ,TRA_DT              --成交日期
       ,BAG_TM              --成交时间
       ,BAG_STATUS_CD       --成交状态代码
       ,CLEAR_STATUS_CD     --清算状态代码
       ,QUOT_BILL_ID        --报价单编号
       ,MEM_ORG_CD          --会员机构代码
       ,NON_LP_PROD_ID      --非法人产品编号
       ,DEALER_ID           --交易员编号
       ,CAP_ACCT            --资金账户
       ,CNTPTY_ORG_CD       --对手机构代码
       ,CNTPTY_DEALER_ID    --对手交易员编号
       ,CNTPTY_CAP_ACCT     --对手资金账户
       ,QUOT_BILL_STATUS_CD --报价单状态代码
       ,DCOTIN_RS_CD        --中止原因代码
       ,LOCK_FLG            --锁定标志
       ,FINAL_MODIF_TM      --最后修改时间
       ,EXP_CLEAR_STATUS_CD --到期清算状态代码
       ,NEST_LOCK_IND       --嵌套锁标志
       ,CREATE_DT           --创建日期
       ,UPDATE_DT           --更新日期
       ,ETL_DT              --ETL处理日期
       ,ID_MARK             --增删标志
       ,SRC_TABLE_NAME      --源表名称
       ,JOB_CD              --任务编码
       ,ETL_TIMESTAMP       --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
        AGT_ID              --协议编号
       ,LP_ID               --法人编号
       ,CTR_NT_TAB_ID       --成交单表编号
       ,BATCH_ID            --批次编号
       ,CTR_NT_ID           --成交单编号
       ,TRAN_DIR_CD         --交易方向代码
       ,BUS_TYPE_CD         --业务类型代码
       ,BILL_TYPE_CD        --票据类型代码
       ,BILL_MED_CD         --票据介质代码
       ,BAG_WAY_CD          --成交方式代码
       ,TRA_DT              --成交日期
       ,BAG_TM              --成交时间
       ,BAG_STATUS_CD       --成交状态代码
       ,CLEAR_STATUS_CD     --清算状态代码
       ,QUOT_BILL_ID        --报价单编号
       ,MEM_ORG_CD          --会员机构代码
       ,NON_LP_PROD_ID      --非法人产品编号
       ,DEALER_ID           --交易员编号
       ,CAP_ACCT            --资金账户
       ,CNTPTY_ORG_CD       --对手机构代码
       ,CNTPTY_DEALER_ID    --对手交易员编号
       ,CNTPTY_CAP_ACCT     --对手资金账户
       ,QUOT_BILL_STATUS_CD --报价单状态代码
       ,DCOTIN_RS_CD        --中止原因代码
       ,LOCK_FLG            --锁定标志
       ,FINAL_MODIF_TM      --最后修改时间
       ,EXP_CLEAR_STATUS_CD --到期清算状态代码
       ,NEST_LOCK_IND       --嵌套锁标志
       ,CREATE_DT           --创建日期
       ,UPDATE_DT           --更新日期
       ,ETL_DT              --ETL处理日期
       ,ID_MARK             --增删标志
       ,SRC_TABLE_NAME      --源表名称
       ,JOB_CD              --任务编码
       ,ETL_TIMESTAMP       --ETL处理时间戳
    FROM IML.V_AGT_DILG_QUOT_CTR_NT   --对话报价成交单_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D'
       ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_O_IML_AGT_DILG_QUOT_CTR_NT;
/

