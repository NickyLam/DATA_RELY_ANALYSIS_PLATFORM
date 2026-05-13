CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_AMSS_POINTS_MALL_PAY_ORDER(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：积分商城-订单表
  **存储过程名称：    ETL_O_IOL_AMSS_POINTS_MALL_PAY_ORDER
  **存储过程创建日期：20250919
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250919    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_AMSS_POINTS_MALL_PAY_ORDER'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_AMSS_POINTS_MALL_PAY_ORDER';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-积分商城-订单表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_AMSS_POINTS_MALL_PAY_ORDER NOLOGGING 
  (          SERIAL_NUM              --流水号
            ,TXN_DATE                --交易日期
            ,TXN_TIME                --交易时间
            ,ORDER_NUM               --积分商城订单号
            ,PAY_TYPE                --1-支付 2-退款
            ,PTY_ID                  --客户号
            ,PTY_RANK                --客户等级
            ,PTY_NAME                --客户名称
            ,IDEN_TYPE_CD            --证件类型
            ,CERT_NUM                --证件号码
            ,PTY_OPEN_ORG            --客户开户机构
            ,AGENTS_ID               --代理商编号
            ,MRCHD_TYPE              --商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
            ,TXN_CODE                --交易码
            ,GROSS_QTTY_AMT          --订单总金额
            ,GROSS_QTTY_POINTS       --订单总积分
            ,POINTS_TYPE             --订单积分类型
            ,ENTITLEMENT_POINT       --订单权益积分
            ,REM_AMT                 --剩余可用金额
            ,REM_POINTS              --剩余可用积分
            ,REM_ENTITLEMENT_POINT   --剩余可用权益积分
            ,TXN_STATUS              --交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
            ,PAYMENT_SUCCESS_DATE    --付款成功日期
            ,PAY_CARD_NUM            --支付卡号
            ,OPEN_ORG_NUM            --支付卡开户机构
            ,ACCT_NUM_NAME           --支付卡名称
            ,BANK_NAME               --银行名称
            ,EXCH_BRCH_NO            --联行号
            ,CARD_TYPE               --卡类型 1-1类卡 2-2类卡 3-3类卡
            ,WTHR_CHECK_BAL          --是否检查余额 0否 1是 空否
            ,FRET_AMT                --运费金额
            ,CONS_NAME               --收货人姓名
            ,CONS_CEPH_NUM           --收货人手机号
            ,CONS_LOC_PROV           --收货人所在省
            ,CONS_LOC_CITY           --收货人所在市
            ,CONS_LOC_CUTY           --收货人所在县（区）
            ,CONS_LOC_TOWN           --收货人所在镇
            ,CONS_DTL_LOC            --收货人详细地址
            ,PICK_GOODS_MODE         --提货方式
            ,PTY_MGR_NUM             --银行客户经理号
            ,TXN_ORG_NUM             --交易机构号
            ,ORIG_ORDER_NUM          --原交易订单号
            ,ORIG_TRX_DT             --原订单交易日期
            ,SRV_RESP_CODE           --响应码
            ,SRV_RESP_INFO           --响应描述
            ,MERCH_NUM               --商户号
            ,CHANNEL_ID              --所属机构
            ,CNSM_TYP                --消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
            ,PHYSICS_FLAG            --物理标识 1-正常 2-删除
            ,CREATE_TIME             --创建时间
            ,UPDATE_TIME             --更新时间
            ,CREATE_EMP              --创建人
            ,UPDATE_EMP              --更新人
            ,PAY_SERIAL_NUM          --原交易平台流水号（退款用）
            ,PAY_ORDER_NUM           --原交易订单号（退款用）
            ,GROSS_FJL               --订单总福利金
            ,REM_FLJ                 --剩余福利金
            ,RETURN_FLAG             --组合支付回滚标志
            ,TXN_NUM                 --交易流水号
            ,NOTIFY_FLAG             --是否通知成功 (0-失败 1-成功)
            ,NOTIFY_COUNT            --支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
            ,START_DT                --开始时间
            ,END_DT                  --结束时间
            ,ID_MARK                 --增删标志
            ,ETL_TIMESTAMP           --ETL处理时间戳
    )
    SELECT
             SERIAL_NUM              --流水号
            ,TXN_DATE                --交易日期
            ,TXN_TIME                --交易时间
            ,ORDER_NUM               --积分商城订单号
            ,PAY_TYPE                --1-支付 2-退款
            ,PTY_ID                  --客户号
            ,PTY_RANK                --客户等级
            ,PTY_NAME                --客户名称
            ,IDEN_TYPE_CD            --证件类型
            ,CERT_NUM                --证件号码
            ,PTY_OPEN_ORG            --客户开户机构
            ,AGENTS_ID               --代理商编号
            ,MRCHD_TYPE              --商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
            ,TXN_CODE                --交易码
            ,GROSS_QTTY_AMT          --订单总金额
            ,GROSS_QTTY_POINTS       --订单总积分
            ,POINTS_TYPE             --订单积分类型
            ,ENTITLEMENT_POINT       --订单权益积分
            ,REM_AMT                 --剩余可用金额
            ,REM_POINTS              --剩余可用积分
            ,REM_ENTITLEMENT_POINT   --剩余可用权益积分
            ,TXN_STATUS              --交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
            ,PAYMENT_SUCCESS_DATE    --付款成功日期
            ,PAY_CARD_NUM            --支付卡号
            ,OPEN_ORG_NUM            --支付卡开户机构
            ,ACCT_NUM_NAME           --支付卡名称
            ,BANK_NAME               --银行名称
            ,EXCH_BRCH_NO            --联行号
            ,CARD_TYPE               --卡类型 1-1类卡 2-2类卡 3-3类卡
            ,WTHR_CHECK_BAL          --是否检查余额 0否 1是 空否
            ,FRET_AMT                --运费金额
            ,CONS_NAME               --收货人姓名
            ,CONS_CEPH_NUM           --收货人手机号
            ,CONS_LOC_PROV           --收货人所在省
            ,CONS_LOC_CITY           --收货人所在市
            ,CONS_LOC_CUTY           --收货人所在县（区）
            ,CONS_LOC_TOWN           --收货人所在镇
            ,CONS_DTL_LOC            --收货人详细地址
            ,PICK_GOODS_MODE         --提货方式
            ,PTY_MGR_NUM             --银行客户经理号
            ,TXN_ORG_NUM             --交易机构号
            ,ORIG_ORDER_NUM          --原交易订单号
            ,ORIG_TRX_DT             --原订单交易日期
            ,SRV_RESP_CODE           --响应码
            ,SRV_RESP_INFO           --响应描述
            ,MERCH_NUM               --商户号
            ,CHANNEL_ID              --所属机构
            ,CNSM_TYP                --消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
            ,PHYSICS_FLAG            --物理标识 1-正常 2-删除
            ,CREATE_TIME             --创建时间
            ,UPDATE_TIME             --更新时间
            ,CREATE_EMP              --创建人
            ,UPDATE_EMP              --更新人
            ,PAY_SERIAL_NUM          --原交易平台流水号（退款用）
            ,PAY_ORDER_NUM           --原交易订单号（退款用）
            ,GROSS_FJL               --订单总福利金
            ,REM_FLJ                 --剩余福利金
            ,RETURN_FLAG             --组合支付回滚标志
            ,TXN_NUM                 --交易流水号
            ,NOTIFY_FLAG             --是否通知成功 (0-失败 1-成功)
            ,NOTIFY_COUNT            --支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
            ,START_DT                --开始时间
            ,END_DT                  --结束时间
            ,ID_MARK                 --增删标志
            ,ETL_TIMESTAMP           --ETL处理时间戳
  FROM IOL.V_AMSS_POINTS_MALL_PAY_ORDER --视图-积分商城-订单表
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_AMSS_POINTS_MALL_PAY_ORDER', '', O_ERRCODE);

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

END ETL_O_IOL_AMSS_POINTS_MALL_PAY_ORDER;
/

