CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_DC_PRECONTRACT(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：大额存单登记表
  **存储过程名称：    ETL_O_IOL_NCBS_RB_DC_PRECONTRACT
  **存储过程创建日期：20251210
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251210    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_NCBS_RB_DC_PRECONTRACT'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NCBS_RB_DC_PRECONTRACT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-大额存单登记表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NCBS_RB_DC_PRECONTRACT NOLOGGING 
  (     ACCT_NAME                --账户名称
       ,ACCT_SEQ_NO              --账户子账号
       ,ACCT_STATUS              --账户状态
       ,BASE_ACCT_NO             --交易账号/卡号
       ,CLIENT_NO                --客户编号
       ,INT_TYPE                 --利率类型
       ,INTERNAL_KEY             --账户内部键值
       ,PROD_TYPE                --产品编号
       ,REFERENCE                --交易参考号
       ,USER_ID                  --交易柜员编号
       ,VOUCHER_NO               --凭证号码
       ,WITHDRAWAL_TYPE          --支取方式
       ,ACCT_NATURE              --存款账户类型
       ,AUTO_SETTLE_FLAG         --自动结清标志
       ,COMPANY                  --法人
       ,CYCLE_FREQ               --结息频率
       ,CYCLE_INT_FLAG           --按频率付息标志
       ,EMAIL                    --电子邮件
       ,INT_CALC_TYPE            --计息类型
       ,ISSUE_YEAR               --发行年度
       ,NARRATIVE                --摘要
       ,PRECONTRACT_NO           --预约号
       ,PRECONTRACT_STATUS       --期次产品预约状态
       ,PRECONTRACT_TYPE         --预约登记的账户类型
       ,PRINT_CNT                --打印次数
       ,RES_SEQ_NO               --限制编号
       ,SEQ_NO                   --序号
       ,SOURCE_TYPE              --渠道编号
       ,STAGE_CODE               --期次代码
       ,STAGE_PROD_CLASS         --期次产品分类
       ,CHANNEL                  --渠道
       ,DELETE_DATE              --删除日期
       ,ISSUE_END_DATE           --发行终止日期
       ,ISSUE_START_DATE         --发行起始日期
       ,NEXT_CYCLE_DATE          --下一结息日
       ,PLEDGED_FLAG             --质押标志
       ,PRECONTRACT_DATE         --预约登记日期
       ,PRECONTRACT_OPEN_DATE    --预约开户日期
       ,REDEEM_DATE              --资产赎回日期
       ,TRAN_TIMESTAMP           --交易时间戳
       ,ACCT_CCY                 --账户币种
       ,ACTUAL_RATE              --行内利率
       ,AUTH_USER_ID             --授权柜员
       ,DEL_AUTH_USER_ID         --删除授权柜员
       ,DEL_REASON               --删除原因
       ,DEL_USER_ID              --删除柜员
       ,FAILURE_REASON           --失败原因
       ,FLOAT_RATE               --浮动利率
       ,ISSUE_AMT                --期次发行金额
       ,OTH_ACCT_NAME            --对方账户名称
       ,OTH_ACCT_SEQ_NO          --对方账户序列号
       ,OTH_BASE_ACCT_NO         --对方账号/卡号
       ,OTH_CCY                  --对手账户币种
       ,OTH_INTERNAL_KEY         --对手账户内部键
       ,OTH_PROD_TYPE            --对方账户产品类型
       ,PRECONTRACT_AMT          --预约金额
       ,PRECONTRACT_BRANCH       --预约/认购机构
       ,PRECONTRACT_CCY          --期次产品预约币种
       ,REAL_RATE                --执行利率
       ,TRAN_AMT                 --交易金额
       ,INT_DAY                  --存贷结息日期
       ,HANG_SEQ_NO              --挂账序列号
       ,DEP_TERM_INTERNAL_KEY    --定期一本通账户内部键
       ,ACCT_INT_TYPE            --计息方法
       ,SUBS_INTERNAL_KEY        --认购账户内部键
       ,COMB_PROD_NO             --组合产品编号
       ,CHARGE_INT_INTERNAL_KEY  --收息账户内部键
       ,SUB_HANG_SEQ_NO          --追加挂账子序号
       ,EXP_REDEEM_INT_AMT       --预计赎回利息
       ,CANCEL_DATE              --撤单日期|撤单日期
       ,DEPOSIT_NATURE           --存款性质
       ,START_DT                 --开始时间
       ,END_DT                   --结束时间
       ,ID_MARK                  --增删标志
       ,ETL_TIMESTAMP            --ETL处理时间戳
    )
  SELECT 
        ACCT_NAME                --账户名称
       ,ACCT_SEQ_NO              --账户子账号
       ,ACCT_STATUS              --账户状态
       ,BASE_ACCT_NO             --交易账号/卡号
       ,CLIENT_NO                --客户编号
       ,INT_TYPE                 --利率类型
       ,INTERNAL_KEY             --账户内部键值
       ,PROD_TYPE                --产品编号
       ,REFERENCE                --交易参考号
       ,USER_ID                  --交易柜员编号
       ,VOUCHER_NO               --凭证号码
       ,WITHDRAWAL_TYPE          --支取方式
       ,ACCT_NATURE              --存款账户类型
       ,AUTO_SETTLE_FLAG         --自动结清标志
       ,COMPANY                  --法人
       ,CYCLE_FREQ               --结息频率
       ,CYCLE_INT_FLAG           --按频率付息标志
       ,EMAIL                    --电子邮件
       ,INT_CALC_TYPE            --计息类型
       ,ISSUE_YEAR               --发行年度
       ,NARRATIVE                --摘要
       ,PRECONTRACT_NO           --预约号
       ,PRECONTRACT_STATUS       --期次产品预约状态
       ,PRECONTRACT_TYPE         --预约登记的账户类型
       ,PRINT_CNT                --打印次数
       ,RES_SEQ_NO               --限制编号
       ,SEQ_NO                   --序号
       ,SOURCE_TYPE              --渠道编号
       ,STAGE_CODE               --期次代码
       ,STAGE_PROD_CLASS         --期次产品分类
       ,CHANNEL                  --渠道
       ,DELETE_DATE              --删除日期
       ,ISSUE_END_DATE           --发行终止日期
       ,ISSUE_START_DATE         --发行起始日期
       ,NEXT_CYCLE_DATE          --下一结息日
       ,PLEDGED_FLAG             --质押标志
       ,PRECONTRACT_DATE         --预约登记日期
       ,PRECONTRACT_OPEN_DATE    --预约开户日期
       ,REDEEM_DATE              --资产赎回日期
       ,TRAN_TIMESTAMP           --交易时间戳
       ,ACCT_CCY                 --账户币种
       ,ACTUAL_RATE              --行内利率
       ,AUTH_USER_ID             --授权柜员
       ,DEL_AUTH_USER_ID         --删除授权柜员
       ,DEL_REASON               --删除原因
       ,DEL_USER_ID              --删除柜员
       ,FAILURE_REASON           --失败原因
       ,FLOAT_RATE               --浮动利率
       ,ISSUE_AMT                --期次发行金额
       ,OTH_ACCT_NAME            --对方账户名称
       ,OTH_ACCT_SEQ_NO          --对方账户序列号
       ,OTH_BASE_ACCT_NO         --对方账号/卡号
       ,OTH_CCY                  --对手账户币种
       ,OTH_INTERNAL_KEY         --对手账户内部键
       ,OTH_PROD_TYPE            --对方账户产品类型
       ,PRECONTRACT_AMT          --预约金额
       ,PRECONTRACT_BRANCH       --预约/认购机构
       ,PRECONTRACT_CCY          --期次产品预约币种
       ,REAL_RATE                --执行利率
       ,TRAN_AMT                 --交易金额
       ,INT_DAY                  --存贷结息日期
       ,HANG_SEQ_NO              --挂账序列号
       ,DEP_TERM_INTERNAL_KEY    --定期一本通账户内部键
       ,ACCT_INT_TYPE            --计息方法
       ,SUBS_INTERNAL_KEY        --认购账户内部键
       ,COMB_PROD_NO             --组合产品编号
       ,CHARGE_INT_INTERNAL_KEY  --收息账户内部键
       ,SUB_HANG_SEQ_NO          --追加挂账子序号
       ,EXP_REDEEM_INT_AMT       --预计赎回利息
       ,CANCEL_DATE              --撤单日期|撤单日期
       ,DEPOSIT_NATURE           --存款性质
       ,START_DT                 --开始时间
       ,END_DT                   --结束时间
       ,ID_MARK                  --增删标志
       ,ETL_TIMESTAMP            --ETL处理时间戳
    FROM IOL.V_NCBS_RB_DC_PRECONTRACT --视图-大额存单登记表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_NCBS_RB_DC_PRECONTRACT', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_NCBS_RB_DC_PRECONTRACT;
/

