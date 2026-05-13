CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_DC_STAGE_DEFINE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：期次定义表
  **存储过程名称：    ETL_O_IOL_NCBS_RB_DC_STAGE_DEFINE
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_NCBS_RB_DC_STAGE_DEFINE'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NCBS_RB_DC_STAGE_DEFINE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-期次定义表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NCBS_RB_DC_STAGE_DEFINE NOLOGGING 
  (       CCY                    --币种
         ,PROD_TYPE              --产品编号
         ,USER_ID                --交易柜员编号
         ,TERM                   --存期
         ,TERM_TYPE              --期限单位
         ,AUTO_SETTLE_FLAG       --自动结清标志
         ,BACK_STATUS            --额度回收状态
         ,COMPANY                --法人
         ,ERROR_DESC             --错误描述
         ,INT_CALC_TYPE          --计息类型
         ,ISSUE_YEAR             --发行年度
         ,OPERATE_METHOD         --配额类型
         ,PART_WITHDRAW_NUM      --部提次数
         ,PAY_INT_TYPE           --付息方式
         ,PRE_WITHDRAW_FLAG      --是否允许提前支取
         ,RATION_TYPE            --配售方式
         ,REDEMPTION_FLAG        --是否可赎回
         ,RESET_INT_FREQ         --利率重置频率
         ,SALE_TYPE              --销售方式
         ,STAGE_CODE             --期次代码
         ,STAGE_CODE_DESC        --期次描述
         ,STAGE_LIMIT_CLASS      --额度扣减类型
         ,STAGE_PROD_CLASS       --期次产品分类
         ,STAGE_STATUS           --期次状态
         ,TRANSFER_FLAG          --转账标志
         ,ISSUE_END_DATE         --发行终止日期
         ,ISSUE_START_DATE       --发行起始日期
         ,PRECONTRACT_END_TIME   --预约结束时间
         ,PRECONTRACT_START_TIME --预约开始时间
         ,SALE_END_TIME          --止售时间
         ,SALE_START_TIME        --起售时间
         ,TRAN_DATE              --交易日期
         ,TRAN_TIMESTAMP         --交易时间戳
         ,DISTRIBUTE_LIMIT       --已分配额度
         ,GET_INT_FREQ           --取息频率
         ,HOLDING_LIMIT          --已占用额度
         ,LEAVE_LIMIT            --剩余额度
         ,STAGE_MAX_AMT          --期次最大购买金额
         ,STAGE_MIN_AMT          --期次起存金额
         ,STAGE_REMARK           --期次详细备注
         ,TOTAL_LIMIT            --总额度
         ,TRAN_BRANCH            --核心交易机构编号
         ,WHITE_SELL_FLAG        --是否白名单发售
         ,ISSUE_END_TIME         --发行终止时间
         ,ISSUE_START_TIME       --发行起始时间
         ,ALLOW_BUY_WAY_CD       --支持组合购买方式
         ,START_DT               --开始时间
         ,END_DT                 --结束时间
         ,ID_MARK                --增删标志
         ,ETL_TIMESTAMP          --ETL处理时间戳
    )
  SELECT 
         CCY                    --币种
         ,PROD_TYPE              --产品编号
         ,USER_ID                --交易柜员编号
         ,TERM                   --存期
         ,TERM_TYPE              --期限单位
         ,AUTO_SETTLE_FLAG       --自动结清标志
         ,BACK_STATUS            --额度回收状态
         ,COMPANY                --法人
         ,ERROR_DESC             --错误描述
         ,INT_CALC_TYPE          --计息类型
         ,ISSUE_YEAR             --发行年度
         ,OPERATE_METHOD         --配额类型
         ,PART_WITHDRAW_NUM      --部提次数
         ,PAY_INT_TYPE           --付息方式
         ,PRE_WITHDRAW_FLAG      --是否允许提前支取
         ,RATION_TYPE            --配售方式
         ,REDEMPTION_FLAG        --是否可赎回
         ,RESET_INT_FREQ         --利率重置频率
         ,SALE_TYPE              --销售方式
         ,STAGE_CODE             --期次代码
         ,STAGE_CODE_DESC        --期次描述
         ,STAGE_LIMIT_CLASS      --额度扣减类型
         ,STAGE_PROD_CLASS       --期次产品分类
         ,STAGE_STATUS           --期次状态
         ,TRANSFER_FLAG          --转账标志
         ,ISSUE_END_DATE         --发行终止日期
         ,ISSUE_START_DATE       --发行起始日期
         ,PRECONTRACT_END_TIME   --预约结束时间
         ,PRECONTRACT_START_TIME --预约开始时间
         ,SALE_END_TIME          --止售时间
         ,SALE_START_TIME        --起售时间
         ,TRAN_DATE              --交易日期
         ,TRAN_TIMESTAMP         --交易时间戳
         ,DISTRIBUTE_LIMIT       --已分配额度
         ,GET_INT_FREQ           --取息频率
         ,HOLDING_LIMIT          --已占用额度
         ,LEAVE_LIMIT            --剩余额度
         ,STAGE_MAX_AMT          --期次最大购买金额
         ,STAGE_MIN_AMT          --期次起存金额
         ,STAGE_REMARK           --期次详细备注
         ,TOTAL_LIMIT            --总额度
         ,TRAN_BRANCH            --核心交易机构编号
         ,WHITE_SELL_FLAG        --是否白名单发售
         ,ISSUE_END_TIME         --发行终止时间
         ,ISSUE_START_TIME       --发行起始时间
         ,ALLOW_BUY_WAY_CD       --支持组合购买方式
         ,START_DT               --开始时间
         ,END_DT                 --结束时间
         ,ID_MARK                --增删标志
         ,ETL_TIMESTAMP          --ETL处理时间戳
    FROM IOL.V_NCBS_RB_DC_STAGE_DEFINE --视图-期次定义表
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_NCBS_RB_DC_STAGE_DEFINE', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_NCBS_RB_DC_STAGE_DEFINE;
/

