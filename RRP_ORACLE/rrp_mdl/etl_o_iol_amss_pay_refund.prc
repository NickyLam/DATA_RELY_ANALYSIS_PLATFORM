CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_AMSS_PAY_REFUND(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：退款单表
  **存储过程名称：    ETL_O_IOL_AMSS_PAY_REFUND
  **存储过程创建日期：20250508
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250508    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_AMSS_PAY_REFUND'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_AMSS_PAY_REFUND';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-退款单表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_AMSS_PAY_REFUND NOLOGGING 
  (         REFUND_NO			            --退款单号
            ,ORDER_NO			            --订单号
            ,MCH_ID			              --商户ID
            ,TOTAL_FEE		            --订单总额
            ,REFUND_FEE               --退款总额
            ,ADD_TIME                 --添加时间
            ,REFUND_STATE             --退款状态
            ,ORDER_STATE              --订单状态
            ,TRADE_TYPE               --支付类型
            ,TRADE_NAME               --支付名称
            ,REFUNDID                 --第三方退款单号
            ,TRANSACTION_ID           --第三方订单号
            ,OUT_REFUND_NO            --商户退款单号
            ,OUT_TRADE_NO             --商户订单号
            ,REFUND_CHANNEL           --退款渠道
            ,REFUND_USER              --退款用户
            ,UPDATE_VERSION           --版本号
            ,MCH_AUDIT                --商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过
            ,DAEMON_AUDIT             --支付退款审核状态.0：初始，1：退回，2：审核通过
            ,REFUND_TIME              --退款时间
            ,REFUSE_REASON            --支付退款理由
            ,MCH_REFUSE_REASON        --商户退款理由
            ,REFUND_SOURCE            --退款来源
            ,MCH_NO                   --商户编号
            ,MCH_NAME                 --商户名称
            ,FEE_TYPE                 --币种
            ,GROUP_ID                 --组织编号
            ,GROUPNO                  --组织编号
            ,CENTER_ID                --支付中心
            ,RISK_CTR                 --风控状态.0初始化、1风控正常，2没设分控,3:分控异常
            ,RISK_INFO                --分控信息
            ,MCH_AUDIT_USER           --商户审核用户
            ,PT_AUDIT_USER            --平台审核用户
            ,BANK_NO                  --银行编码
            ,AGENTNO                  --代理商编号
            ,DEPARNO                  --门店部门编号
            ,TERMTYPE                 --终端类型.POS,SPAY,ADMIN
            ,TERMNO                   --终端编号.如果是ADMIN退款终端编号填写用户操作IP
            ,OPERNO                   --操作员编号
            ,SHOPNO                   --操作门店编号
            ,MCH_REVIEW_TIME          --商户审核时间
            ,PT_REVIEW_TIME           --平台审核时间
            ,AGENTID                  --代理商编号
            ,GROUP_NO      
            ,CLIENT_IP      
            ,DATA_SIGN      
            ,MODIFY_TIME      
            ,MDISCOUNT      
            ,UNION_ID      
            ,BANK_TYPE      
            ,OPENID      
            ,SUB_OPENID      
            ,FLD_S1      
            ,FLD_S2      
            ,FLD_S3      
            ,BS_DISCOUNT               --银联自定义优惠退款金额
            ,BS_DISCOUNT_TYPE          --银联自定义优惠类型
            ,SIGN_AGENTNO              --授权机构号
            ,FLD_S4      
            ,FLD_S5      
            ,FLD_S6      
            ,FLD_S7      
            ,FLD_S8      
            ,MCH_DISCOUNT_AMOUNT        --商家优惠金额，单位:分(计费字段，后续拆分)
            ,PLAT_DISCOUNT_AMOUNT       --平台优惠金额，单位:分(计费字段，后续拆分)
            ,MCH_RATE_TYPE              --费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,MCH_RATE                   --商户费率，百万单位存储(计费字段，后续拆分)
            ,COST_RATE                  --通道费率，百万单位存储(计费字段，后续拆分)
            ,MCH_THEORY_PROCEDURE_FEE   --商户理论手续费，单位:分(计费字段，后续拆分)
            ,MCH_REAL_PROCEDURE_FEE     --商户实际手续费，单位:分(计费字段，后续拆分)
            ,MCH_DISCOUNT_FEE           --商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,DEBIT_CARD_BROKERAGE_LIMIT --商户封顶手续费，单位:分(计费字段，后续拆分)
            ,ORI_MCH_THEORY_FEE         --原交易订单商户理论手续费，单位:分(计费字段，后续拆分)
            ,ORI_MCH_REAL_FEE           --原交易订单商户实际手续费，单位:分(计费字段，后续拆分)
            ,CALC_STATE                 --手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)
            ,API_PROVIDER               --接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,PAY_CENTER_ID              --支付通道ID，对应通道表主键
            ,QUICK_SERIAL_NO      
            ,ACC_WAY_PERIOD             --结算周期
            ,ACCT_DT                    --会计日，格式20240808
            ,START_DT                   --开始时间
            ,END_DT                     --结束时间
            ,ID_MARK                    --增删标志
            ,ETL_TIMESTAMP              --ETL处理时间戳
    )
    SELECT
           REFUND_NO			            --退款单号
            ,ORDER_NO			            --订单号
            ,MCH_ID			              --商户ID
            ,TOTAL_FEE		            --订单总额
            ,REFUND_FEE               --退款总额
            ,ADD_TIME                 --添加时间
            ,REFUND_STATE             --退款状态
            ,ORDER_STATE              --订单状态
            ,TRADE_TYPE               --支付类型
            ,TRADE_NAME               --支付名称
            ,REFUNDID                 --第三方退款单号
            ,TRANSACTION_ID           --第三方订单号
            ,OUT_REFUND_NO            --商户退款单号
            ,OUT_TRADE_NO             --商户订单号
            ,REFUND_CHANNEL           --退款渠道
            ,REFUND_USER              --退款用户
            ,UPDATE_VERSION           --版本号
            ,MCH_AUDIT                --商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过
            ,DAEMON_AUDIT             --支付退款审核状态.0：初始，1：退回，2：审核通过
            ,REFUND_TIME              --退款时间
            ,REFUSE_REASON            --支付退款理由
            ,MCH_REFUSE_REASON        --商户退款理由
            ,REFUND_SOURCE            --退款来源
            ,MCH_NO                   --商户编号
            ,MCH_NAME                 --商户名称
            ,FEE_TYPE                 --币种
            ,GROUP_ID                 --组织编号
            ,GROUPNO                  --组织编号
            ,CENTER_ID                --支付中心
            ,RISK_CTR                 --风控状态.0初始化、1风控正常，2没设分控,3:分控异常
            ,RISK_INFO                --分控信息
            ,MCH_AUDIT_USER           --商户审核用户
            ,PT_AUDIT_USER            --平台审核用户
            ,BANK_NO                  --银行编码
            ,AGENTNO                  --代理商编号
            ,DEPARNO                  --门店部门编号
            ,TERMTYPE                 --终端类型.POS,SPAY,ADMIN
            ,TERMNO                   --终端编号.如果是ADMIN退款终端编号填写用户操作IP
            ,OPERNO                   --操作员编号
            ,SHOPNO                   --操作门店编号
            ,MCH_REVIEW_TIME          --商户审核时间
            ,PT_REVIEW_TIME           --平台审核时间
            ,AGENTID                  --代理商编号
            ,GROUP_NO      
            ,CLIENT_IP      
            ,DATA_SIGN      
            ,MODIFY_TIME      
            ,MDISCOUNT      
            ,UNION_ID      
            ,BANK_TYPE      
            ,OPENID      
            ,SUB_OPENID      
            ,FLD_S1      
            ,FLD_S2      
            ,FLD_S3      
            ,BS_DISCOUNT               --银联自定义优惠退款金额
            ,BS_DISCOUNT_TYPE          --银联自定义优惠类型
            ,SIGN_AGENTNO              --授权机构号
            ,FLD_S4      
            ,FLD_S5      
            ,FLD_S6      
            ,FLD_S7      
            ,FLD_S8      
            ,MCH_DISCOUNT_AMOUNT        --商家优惠金额，单位:分(计费字段，后续拆分)
            ,PLAT_DISCOUNT_AMOUNT       --平台优惠金额，单位:分(计费字段，后续拆分)
            ,MCH_RATE_TYPE              --费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,MCH_RATE                   --商户费率，百万单位存储(计费字段，后续拆分)
            ,COST_RATE                  --通道费率，百万单位存储(计费字段，后续拆分)
            ,MCH_THEORY_PROCEDURE_FEE   --商户理论手续费，单位:分(计费字段，后续拆分)
            ,MCH_REAL_PROCEDURE_FEE     --商户实际手续费，单位:分(计费字段，后续拆分)
            ,MCH_DISCOUNT_FEE           --商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,DEBIT_CARD_BROKERAGE_LIMIT --商户封顶手续费，单位:分(计费字段，后续拆分)
            ,ORI_MCH_THEORY_FEE         --原交易订单商户理论手续费，单位:分(计费字段，后续拆分)
            ,ORI_MCH_REAL_FEE           --原交易订单商户实际手续费，单位:分(计费字段，后续拆分)
            ,CALC_STATE                 --手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)
            ,API_PROVIDER               --接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,PAY_CENTER_ID              --支付通道ID，对应通道表主键
            ,QUICK_SERIAL_NO      
            ,ACC_WAY_PERIOD             --结算周期
            ,ACCT_DT                    --会计日，格式20240808
            ,START_DT                   --开始时间
            ,END_DT                     --结束时间
            ,ID_MARK                    --增删标志
            ,ETL_TIMESTAMP              --ETL处理时间戳
  FROM IOL.V_AMSS_PAY_REFUND --视图-退款单表
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_AMSS_PAY_REFUND', '', O_ERRCODE);

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

END ETL_O_IOL_AMSS_PAY_REFUND;
/

