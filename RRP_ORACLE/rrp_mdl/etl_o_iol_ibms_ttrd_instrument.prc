CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_INSTRUMENT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TTRD_INSTRUMENT
  *  功能描述：金融工具表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_IBMS_TTRD_INSTRUMENT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20241225  YJY      优化脚本
  *             3    20251029  YJY      新增产品编码
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_INSTRUMENT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-金融工具表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT NOLOGGING
    (  I_CODE                --金融工具代码
      ,A_TYPE                --资产类型
      ,M_TYPE                --市场类型
      ,CURRENCY              --币种
      ,I_NAME                --金融工具名称
      ,P_TYPE                --产品类型，用户不可修改，仅代码层面应用
      ,P_CLASS               --产品分类，默认为资产类型名称，用户可以修改
      ,P_LS                  --区分是LONG还是SHORT（L：LONG；S：SHORT）
      ,MTR_DATE              --到期日
      ,TERM                  --如 1Y，6M，7D
      ,U_I_CODE              --标的金融工具
      ,U_A_TYPE              --标的资产类型
      ,U_M_TYPE              --标的市场类型
      ,COUPON_TYPE           --息票类型：1－固定利率；2－浮动利率；3－零息票利率
      ,ISSUE_MODE            --发行模式：1－面值发行；2－贴现发行
      ,PAYMENT_FREQ          --付息周期,如 1Y，6M，7D
      ,CASH_TIMES            --付息次数（一年付息几次）
      ,SENIORITY             --清偿等级（仅用于债券）
      ,PARTY_ID              --发行机构ID
      ,CHINESESPELL          --中文简写
      ,UPDATE_USER           --经办人
      ,UPDATE_TIME           --经办时间
      ,ACCOUNT_USER          --复核人
      ,ACCOUNT_TIME          --复核时间
      ,PAR_VALUE             --发行面额
      ,FWD_IRC               --远期利率曲线
      ,DIS_IRC               --折现利率曲线
      ,COUPON                --票面利率或利差
      ,PREVIOUS_VERSION_MTR_DATE  --上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
      ,GRP_ID                --组合号
      ,TERM_DAY              --期限天数
      ,REMAIN_TERM_DAY       --剩余期限
      ,ISSUE_VOLUME          --发行数量
      ,STATE                 --状态：0:正常状态  1：指令刷新中
      ,I_ID                  --机构号
      ,START_DATE            --起息日
      ,WEIGHT_LIMIT          --风险权重
      ,T_PATH                --客户分类名称
      ,P_CLASS_ACT           --会计产品分类
      ,ISSUER_ID             --发行人ID
      ,WARRANTOR_ID          --担保人ID
      ,ISSUER_T_PATH         --发行人客户分类名称
      ,B_ACTUAL_MTR_DATE     --债券实际到期日
      ,CORE_ACCT_CODE        --定期帐号核心账户
      ,Q_CURRENCY            --计价货币币种
      ,IS_SPV_ASSET          --是否SPV资产0：否 1：是
      ,REAL_I_CODE           --实际金融工具代码
      ,PRINCIPAL             --本金
      ,FIRST_PAYMENT_DATE    --首次付息日
      ,DAYCOUNT              --计息基准
      ,MATCH_CODE            --
      ,CREDIT_CLASSFY        --授信分类
      ,IS_USING_CREDIT       --是否占用授信，0-不占用，1-占用(仅非标使用)
      ,CREDIT_WEIGHT         --授信权重(%)
      ,APR_TXN               --批复编号
      ,REPLY_CODE            --额度合同编号
      ,START_DT              --开始时间
      ,END_DT                --结束时间
      ,ID_MARK               --增删标志
      ,PROD_CODE             --产品编码   --ADD BY YJY 20251029
     )
  SELECT /*+PARALLEL*/
      I_CODE                --金融工具代码
      ,A_TYPE                --资产类型
      ,M_TYPE                --市场类型
      ,CURRENCY              --币种
      ,I_NAME                --金融工具名称
      ,P_TYPE                --产品类型，用户不可修改，仅代码层面应用
      ,P_CLASS               --产品分类，默认为资产类型名称，用户可以修改
      ,P_LS                  --区分是LONG还是SHORT（L：LONG；S：SHORT）
      ,MTR_DATE              --到期日
      ,TERM                  --如 1Y，6M，7D
      ,U_I_CODE              --标的金融工具
      ,U_A_TYPE              --标的资产类型
      ,U_M_TYPE              --标的市场类型
      ,COUPON_TYPE           --息票类型：1－固定利率；2－浮动利率；3－零息票利率
      ,ISSUE_MODE            --发行模式：1－面值发行；2－贴现发行
      ,PAYMENT_FREQ          --付息周期,如 1Y，6M，7D
      ,CASH_TIMES            --付息次数（一年付息几次）
      ,SENIORITY             --清偿等级（仅用于债券）
      ,PARTY_ID              --发行机构ID
      ,CHINESESPELL          --中文简写
      ,UPDATE_USER           --经办人
      ,UPDATE_TIME           --经办时间
      ,ACCOUNT_USER          --复核人
      ,ACCOUNT_TIME          --复核时间
      ,PAR_VALUE             --发行面额
      ,FWD_IRC               --远期利率曲线
      ,DIS_IRC               --折现利率曲线
      ,COUPON                --票面利率或利差
      ,PREVIOUS_VERSION_MTR_DATE  --上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
      ,GRP_ID                --组合号
      ,TERM_DAY              --期限天数
      ,REMAIN_TERM_DAY       --剩余期限
      ,ISSUE_VOLUME          --发行数量
      ,STATE                 --状态：0:正常状态  1：指令刷新中
      ,I_ID                  --机构号
      ,START_DATE            --起息日
      ,WEIGHT_LIMIT          --风险权重
      ,T_PATH                --客户分类名称
      ,P_CLASS_ACT           --会计产品分类
      ,ISSUER_ID             --发行人ID
      ,WARRANTOR_ID          --担保人ID
      ,ISSUER_T_PATH         --发行人客户分类名称
      ,B_ACTUAL_MTR_DATE     --债券实际到期日
      ,CORE_ACCT_CODE        --定期帐号核心账户
      ,Q_CURRENCY            --计价货币币种
      ,IS_SPV_ASSET          --是否SPV资产0：否 1：是
      ,REAL_I_CODE           --实际金融工具代码
      ,PRINCIPAL             --本金
      ,FIRST_PAYMENT_DATE    --首次付息日
      ,DAYCOUNT              --计息基准
      ,MATCH_CODE            --
      ,CREDIT_CLASSFY        --授信分类
      ,IS_USING_CREDIT       --是否占用授信，0-不占用，1-占用(仅非标使用)
      ,CREDIT_WEIGHT         --授信权重(%)
      ,APR_TXN               --批复编号
      ,REPLY_CODE            --额度合同编号
      ,START_DT              --开始时间
      ,END_DT                --结束时间
      ,ID_MARK               --增删标志
      ,PROD_CODE             --产品编码   --ADD BY YJY 20251029
    FROM IOL.V_IBMS_TTRD_INSTRUMENT   --金融工具表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
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

  END ETL_O_IOL_IBMS_TTRD_INSTRUMENT;
/

