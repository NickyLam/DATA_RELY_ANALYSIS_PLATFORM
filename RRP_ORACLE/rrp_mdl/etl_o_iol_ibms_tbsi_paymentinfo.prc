CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TBSI_PAYMENTINFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TBSI_PAYMENTINFO
  *  功能描述：现金流明细表
  *  创建日期：20251117
  *  开发人员：于敬艺
  *  来源表： IOL.V_IBMS_TBSI_PAYMENTINFO
  *  目标表： O_IOL_IBMS_TBSI_PAYMENTINFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251117  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TBSI_PAYMENTINFO'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TBSI_PAYMENTINFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-现金流明细表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TBSI_PAYMENTINFO NOLOGGING
    (     I_CODE                        --金融工具代码
          ,A_TYPE                       --资产类型
          ,M_TYPE                       --市场类型
          ,TG_CODE                      --任务组代码
          ,PI_ID                        --现金流ID
          ,STREAM_ID                    --利率流ID
          ,PI_FIXED                     --是否是确定现金流
          ,PI_CALCENDDATE               --计息结束日期
          ,PI_PAYMENTDATE               --支付日
          ,PI_AMOUNT                    --金额
          ,PI_DISCOUNT                  --折现率
          ,PI_NOTIONALAMOUNT            --金额中的本金部分
          ,PI_NOTIONALAMOUNT_FORCASTED  --金额中的本金部分中的预测部分
          ,PI_INTERESTAMOUNT            --金额中的利息部分
          ,PI_INTERESTAMOUNT_FORCASTED  --金额中的利息部分中的预测部分
          ,PI_PRENOTIONALAMOUNT         --发生前本金
          ,PI_NEXTNOTIONALAMOUNT        --发生后本金
          ,PI_PREMIUM                   --期权费
          ,PI_PREMIUM_FORCASTED         --期权费中的预测部分
          ,PI_PROBABILITY               --概率
          ,IMP_TIME                     --更新时间
          ,REAL_I_CODE                  --真实的金融工具代码
          ,PI_CALCSTARTDATE             --计息开始日期
          ,PI_CURRENCY                  --币种
          ,PI_SETTLECURRENCY            --结算币种
          ,PI_DISCOUNTTIME              --贴现年化时间
          ,PE_CODE                      --定价环境代码
          ,BEG_DATE                     --计算日期
          ,PI_CUMUDEFAULTRATE           --累积违约概率
          ,I_CODE_RPT                   --
          ,START_DT                     --开始时间
          ,END_DT                       --结束时间
          ,ID_MARK                      --增删标志
          ,ETL_TIMESTAMP               --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
       I_CODE                        --金融工具代码
          ,A_TYPE                       --资产类型
          ,M_TYPE                       --市场类型
          ,TG_CODE                      --任务组代码
          ,PI_ID                        --现金流ID
          ,STREAM_ID                    --利率流ID
          ,PI_FIXED                     --是否是确定现金流
          ,PI_CALCENDDATE               --计息结束日期
          ,PI_PAYMENTDATE               --支付日
          ,PI_AMOUNT                    --金额
          ,PI_DISCOUNT                  --折现率
          ,PI_NOTIONALAMOUNT            --金额中的本金部分
          ,PI_NOTIONALAMOUNT_FORCASTED  --金额中的本金部分中的预测部分
          ,PI_INTERESTAMOUNT            --金额中的利息部分
          ,PI_INTERESTAMOUNT_FORCASTED  --金额中的利息部分中的预测部分
          ,PI_PRENOTIONALAMOUNT         --发生前本金
          ,PI_NEXTNOTIONALAMOUNT        --发生后本金
          ,PI_PREMIUM                   --期权费
          ,PI_PREMIUM_FORCASTED         --期权费中的预测部分
          ,PI_PROBABILITY               --概率
          ,IMP_TIME                     --更新时间
          ,REAL_I_CODE                  --真实的金融工具代码
          ,PI_CALCSTARTDATE             --计息开始日期
          ,PI_CURRENCY                  --币种
          ,PI_SETTLECURRENCY            --结算币种
          ,PI_DISCOUNTTIME              --贴现年化时间
          ,PE_CODE                      --定价环境代码
          ,BEG_DATE                     --计算日期
          ,PI_CUMUDEFAULTRATE           --累积违约概率
          ,I_CODE_RPT                   --
          ,START_DT                     --开始时间
          ,END_DT                       --结束时间
          ,ID_MARK                      --增删标志
          ,ETL_TIMESTAMP               --ETL处理时间戳
    FROM IOL.V_IBMS_TBSI_PAYMENTINFO   --现金流明细表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

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

  END ETL_O_IOL_IBMS_TBSI_PAYMENTINFO;
/

