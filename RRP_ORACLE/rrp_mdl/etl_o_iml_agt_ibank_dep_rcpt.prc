CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_IBANK_DEP_RCPT(I_P_DATE IN INTEGER,
                                                         O_ERRCODE OUT VARCHAR2
                                                         )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_IBANK_DEP_RCPT
  *  功能描述：同业存单表
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  O_IML_AGT_IBANK_DEP_RCPT
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
  *             2    20241225  YJY       优化脚本
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_IBANK_DEP_RCPT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_AGT_IBANK_DEP_RCPT T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--普通表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业存单表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_IBANK_DEP_RCPT
    (VOUCH_ID                 --凭证编号
    ,LP_ID                    --法人编号
    ,DEP_RCPT_CD              --存单代码
    ,ASSET_TYPE_CD            --资产类型代码
    ,MARKET_TYPE_CD           --市场类型代码
    ,CURR_CD                  --币种代码
    ,QUOT_WAY_CD              --报价方式代码
    ,DEP_RCPT_NAME            --存单名称
    ,PROD_TYPE_CD             --产品类型代码
    ,PROD_TYPE_NAME           --产品类型名称
    ,INT_RAT_PCT_SPD_BP       --利率%、利差BP
    ,ISSUE_QTTY               --发行量(亿元)
    ,ISSUE_PRICE              --发行价格
    ,LOWT_ISSUE_PRICE         --最低发行价格
    ,HIGT_ISSUE_PRICE         --最高发行价格
    ,VALUE_DT                 --起息日期
    ,EXP_DT                   --到期日期
    ,TENOR_VAL                --期限值(天)
    ,FIR_INT_RAT_CFM_DT       --首次利率确定日期
    ,PAY_INT_FREQ_CD          --付息频率代码
    ,ISSUE_WAY_CD             --发行方式代码
    ,COUPON_TYPE_CD           --息票类型代码
    ,BASE_RAT_ID              --基准利率编号
    ,BASE_ASSET_TYPE_ID       --基准资产类型编号
    ,BASE_MARKET_TYPE_ID      --基准市场类型编号
    ,STL_STATUS_CD            --结算状态代码
    ,PAY_DT                   --缴款日期
    ,CASH_DT                  --兑付日期
    ,ISSUE_DT                 --发行日期
    ,ANNUAL_INT_RAT           --年化利率
    ,INT_ACCR_BASE_CD         --计息基准代码
    ,FIR_PAY_INT_DT           --首次付息日期
    ,INVT_BID_WAY_CD          --招标方式代码
    ,LOWT_YLD_RAT             --最低收益率
    ,HIGT_YLD_RAT             --最高收益率
    ,ACTL_ISSUE_QTTY          --实际发行量(亿元)
    ,ISSUER_NAME              --发行人名称
    ,RANGE                    --范围
    ,RATING_ORG               --评级机构
    ,RATING                   --评级
    ,FAC_VAL                  --票面
    ,START_ISSUE_DT           --开始发行日期
    ,END_ISSUE_DT             --结束发行日期
    ,MAX_SUBSCR_QTTY          --最大认购量
    ,MIN_SUBSCR_QTTY          --最小认购量
    ,SIG_MAX_SUBSCR_QTTY      --单笔最大认购量
    ,CREATE_DT                --创建日期
    ,UPDATE_DT                --更新日期
    ,ETL_DT                   --ETL处理日期
    ,ID_MARK                  --增删标志
    ,SRC_TABLE_NAME           --源表名称
    ,JOB_CD                   --任务编码
    )
  SELECT 
     VOUCH_ID                 --凭证编号
    ,LP_ID                    --法人编号
    ,DEP_RCPT_CD              --存单代码
    ,ASSET_TYPE_CD            --资产类型代码
    ,MARKET_TYPE_CD           --市场类型代码
    ,CURR_CD                  --币种代码
    ,QUOT_WAY_CD              --报价方式代码
    ,DEP_RCPT_NAME            --存单名称
    ,PROD_TYPE_CD             --产品类型代码
    ,PROD_TYPE_NAME           --产品类型名称
    ,INT_RAT_PCT_SPD_BP       --利率%、利差BP
    ,ISSUE_QTTY               --发行量(亿元)
    ,ISSUE_PRICE              --发行价格
    ,LOWT_ISSUE_PRICE         --最低发行价格
    ,HIGT_ISSUE_PRICE         --最高发行价格
    ,VALUE_DT                 --起息日期
    ,EXP_DT                   --到期日期
    ,TENOR_VAL                --期限值(天)
    ,FIR_INT_RAT_CFM_DT       --首次利率确定日期
    ,PAY_INT_FREQ_CD          --付息频率代码
    ,ISSUE_WAY_CD             --发行方式代码
    ,COUPON_TYPE_CD           --息票类型代码
    ,BASE_RAT_ID              --基准利率编号
    ,BASE_ASSET_TYPE_ID       --基准资产类型编号
    ,BASE_MARKET_TYPE_ID      --基准市场类型编号
    ,STL_STATUS_CD            --结算状态代码
    ,PAY_DT                   --缴款日期
    ,CASH_DT                  --兑付日期
    ,ISSUE_DT                 --发行日期
    ,ANNUAL_INT_RAT           --年化利率
    ,INT_ACCR_BASE_CD         --计息基准代码
    ,FIR_PAY_INT_DT           --首次付息日期
    ,INVT_BID_WAY_CD          --招标方式代码
    ,LOWT_YLD_RAT             --最低收益率
    ,HIGT_YLD_RAT             --最高收益率
    ,ACTL_ISSUE_QTTY          --实际发行量(亿元)
    ,ISSUER_NAME              --发行人名称
    ,RANGE                    --范围
    ,RATING_ORG               --评级机构
    ,RATING                   --评级
    ,FAC_VAL                  --票面
    ,START_ISSUE_DT           --开始发行日期
    ,END_ISSUE_DT             --结束发行日期
    ,MAX_SUBSCR_QTTY          --最大认购量
    ,MIN_SUBSCR_QTTY          --最小认购量
    ,SIG_MAX_SUBSCR_QTTY      --单笔最大认购量
    ,CREATE_DT                --创建日期
    ,UPDATE_DT                --更新日期
    ,ETL_DT                   --ETL处理日期
    ,ID_MARK                  --增删标志
    ,SRC_TABLE_NAME           --源表名称
    ,JOB_CD                   --任务编码
    FROM IML.V_AGT_IBANK_DEP_RCPT   --视图-同业存单表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_IBANK_DEP_RCPT', '', O_ERRCODE);

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

END ETL_O_IML_AGT_IBANK_DEP_RCPT;
/

