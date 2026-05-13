CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_SELF_CHN_TXN_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_SELF_CHN_TXN_DTL
  *  功能描述：自助渠道交易流水
  *  创建日期：20220930
  *  开发人员：MW
  *  来源表：
  *
  *
  *
  *
  *  目标表：  M_SELF_CHN_TXN_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_SELF_CHN_TXN_DTL'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME  VARCHAR2(50); --表名
  V_PART_NAME VARCHAR2(100);
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;
  V_TAB_NAME := 'M_SELF_CHN_TXN_DTL';
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM M_SELF_CHN_TXN_DTL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'M_SELF_CHN_TXN_DTL'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入自助渠道交易流水表';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_SELF_CHN_TXN_DTL
        (
        DATA_DT                             --1数据日期
       ,BIZ_SYS_EVT_ID                       --2事件编号
       ,BIZ_SEQ_NUM                          --3业务流水号
       ,EVT_TYP_CD                           --4事件类型代码
       ,TXN_NUM                              --5交易码
       ,TXN_RESP_NUM                         --6交易返回码
       ,TXN_DT                               --7交易日期
       ,TXN_CCY_CD                           --8交易币种代码
       ,TXN_AMT                              --9交易金额
       ,FEE                                  --10手续费
       ,EVT_STATUS_CD                        --11交易状态代码
       ,CHN_TYP_CD                           --12渠道类型代码
       ,TXN_ORG_ID                           --13交易机构编号
       ,TXN_TELLER_ID                        --14交易柜员编号
       ,AGT_ID                               --15交易账户编号
       ,TXN_OCCUR_PLA                        --16交易发生地
       ,MERCH_ID                             --17商户编号
       ,OVSEA_FLG                            --18境外标志
       ,CROSSB_FLG                           --19跨行标志
       ,CNTRPTY_ACCT_NUM_ID                  --20交易对手账户编号
       ,CNTRPTY_ACCT_NUM                     --21交易对手账户名称
       ,PTY_LEG_TYP_CD                       --22客户端类型代码
       ,CARD_TXN_TYP_CD                      --23卡交易类型代码
       ,CARD_TYP_CD                          --24卡类型代码
       ,BNK_CARD_TYP_CD                      --25银行卡类型代码
       ,BNK_CARD_LIQDT_CHN_CD                --26银行卡清算渠道代码
       ,TXN_CTY_PAR                          --27交易国家和地区代码
       ,CARD_FRAME_ORD_NBR                   --28卡组织单号
       ,TXN_MERCH_TYP_CD                     --29交易商户类型代码
       ,TXN_MERCH_NAME                       --30交易商户名称
       ,MERCH_CATEG_NUM                      --31商户类别码
       ,LIQDT_AMT                            --32清算金额
       ,UNPAY_CHN_CD                         --33银联渠道代码
       ,TXN_RESP_DESC                        --34交易返回描述
       ,TERMN_ID                             --35终端编号
       ,ACPT_ORG_CD                          --36收单机构代码
       ,SRV_PNT_INPUT_MODE_CD                --37服务点输入方式代码
       ,PWD_CHECK_FLG                        --38密码校验标志
       ,REV_SEQ_NUM                          --39冲正流水号
       ,DEPT_LINE                            --40部门条线
       ,DATA_SRC                             --41数据来源
       ,TRAN_TM                              --42交易时间
       )
      SELECT 
       V_P_DATE                                                   AS DATA_DT                   --1数据日期
      ,('MPCS'||TRIM(T1.PROC_ORG_ID)||TRIM(T1.SEND_ORG_ID)||TRIM(T1.SYS_FOLLOW_ID)||SUBSTR(T1.TRAN_TM,5)||TRIM(T1.TRAN_TYPE_CD)||TRIM(T1.TRAN_CD))
                                                                  AS BIZ_SYS_EVT_ID             --2事件编号
      ,(TRIM(T1.PROC_ORG_ID)||TRIM(T1.SEND_ORG_ID)||TRIM(T1.SYS_FOLLOW_ID)||SUBSTR(T1.TRAN_TM,5))
                                                                  AS BIZ_SEQ_NUM                --3业务流水号
      ,'L130'                                                     AS EVT_TYP_CD                 --4事件类型代码
      ,T1.INTNAL_TRAN_CD                                          AS TXN_NUM                   --5交易码
      ,CASE WHEN T1.TRAN_STATUS_CD IN ('1','2','7','9') THEN '00' --成功
            WHEN TRIM(T1.ERR_CD) IS NOT NULL THEN T1.ERR_CD
            ELSE '01' 
        END                                                       AS TXN_RESP_NUM              --6交易返回码
      ,TO_CHAR(T1.TRAN_DT,'YYYYMMDD')                             AS TXN_DT                     --7交易日期
      ,REPLACE(T1.CURR_CD,'@','')                                 AS TXN_CCY_CD                 --8交易币种代码
      ,CAST(NVL(
              (
                  CASE WHEN T1.TRAN_TYPE_CD <> '01' THEN T1.TRAN_AMT --本代本、他
                       WHEN TRIM(T1.SEND_ORG_ID) = '00010344' AND T1.CURR_CD = 'CNY' THEN T1.TRAN_AMT --境外人民币
                       WHEN TRIM(T1.SEND_ORG_ID) = '00010344' AND T1.DEDUCT_EXCH_RAT = 0  THEN T1.TRAN_AMT  --异常数据
                       WHEN TRIM(T1.SEND_ORG_ID) = '00010344' AND (T1.TRAN_AMT = 0 OR T1.CLEAR_AMT = 0)  THEN T1.TRAN_AMT
                       WHEN TRIM(T1.SEND_ORG_ID) = '00010344' THEN
                           (
                               CASE WHEN T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT > 0.9 AND T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT < 1.1 THEN T1.TRAN_AMT*100
                                    WHEN T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT > 9 AND T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT < 11 THEN T1.TRAN_AMT*100/10
                                    WHEN T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT > 90 AND T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT < 110 THEN T1.TRAN_AMT*100/100
                                    WHEN T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT > 900 AND T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT < 1100 THEN T1.TRAN_AMT*100/1000
                                    WHEN T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT > 9000 AND T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT < 11000 THEN T1.TRAN_AMT*100/10000
                                    WHEN T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT > 90000 AND T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT < 110000 THEN T1.TRAN_AMT*100/100000
                                    WHEN T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT > 900000 AND T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT < 1100000 THEN T1.TRAN_AMT*100/1000000
                                    WHEN T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT > 9000000 AND T1.TRAN_AMT*100*T1.DEDUCT_EXCH_RAT/T1.CLEAR_AMT < 11000000 THEN T1.TRAN_AMT*100/10000000
                                    ELSE T1.TRAN_AMT
                               END
                           )
                       ELSE T1.TRAN_AMT --境内
                  END
              ), '0.00') AS NUMBER(18,2))                         AS TXN_AMT                    --9交易金额
      ,0.00                                                       AS FEE                        --10手续费
      ,(CASE WHEN SUBSTR(T1.INTNAL_TRAN_CD,7,1) = 'C' AND T1.TRAN_STATUS_CD = '1' THEN '08' --冲正交易
             WHEN T1.INTNAL_TRAN_CD IN ('ZTSA51F94','ZTSA51F16','ZTSA51F10','ZTSA51F12','ZTSA51F18','ZTSA50F94') AND T1.TRAN_STATUS_CD = '1' THEN '09' --撤销交易
             WHEN T1.TRAN_STATUS_CD IN ('1','C') --成功、已成功冻结
             THEN '00'
             WHEN T1.TRAN_STATUS_CD IN ('2') --已冲正
             THEN '00'  --08改00
             WHEN T1.TRAN_STATUS_CD IN ('9') --已撤销
             THEN '00'  --09改00
             WHEN T1.TRAN_STATUS_CD IN ('0','8') --中台失败、核心失败
             THEN '01'
             WHEN T1.TRAN_STATUS_CD IN ('6','7') --6银联成功 7核心成功
             THEN '04'
             ELSE --4已发银联 5已发核心
                  '02' END)                                       AS EVT_STATUS_CD              --11交易状态代码
      ,(CASE WHEN T1.TRAN_TYPE_CD ='01' THEN '2101' --银联，待定
             WHEN T1.TRAN_TYPE_CD ='02' THEN '1003' --ATMP
             ELSE '1001'                            --柜面
             END)                                               AS CHN_TYP_CD                   --12渠道类型代码
      ,(CASE WHEN T1.TRAN_TYPE_CD = '01' AND T1.TRAN_ORG_ID IS NOT NULL THEN T1.TRAN_ORG_ID --发卡默认机构
             ELSE '800001'                                                                  --默认机构（他行）
             END)                                               AS TXN_ORG_ID               --13交易机构编号
      ,TRIM(T1.TELLER_ID)                                       AS TXN_TELLER_ID            --14交易柜员编号
      ,T1.MAIN_ACCT_ID                                          AS AGT_ID                  --15交易账户编号
      ,T1.PROC_MERCHT_NAME                                      AS TXN_OCCUR_PLA           --16交易发生地
      ,(CASE WHEN T1.TRAN_TYPE_CD = '01' AND T1.TERMN_TYPE_CD IN ('01','06') THEN ''   --ATM、柜台没有商户号
             WHEN T1.TRAN_TYPE_CD = '01' AND T1.PROC_MERCHT_ID IS NOT NULL THEN TRIM(T1.PROC_MERCHT_ID)
             ELSE '' END)                                       AS MERCH_ID                 --17商户编号
      ,(CASE WHEN TRIM(T1.SEND_ORG_ID) = '00010344' THEN '1'  --A.CHANNELTP ='1' OR
             ELSE '0' END)                                      AS OVSEA_FLG                --18境外标志
      ,(CASE WHEN T1.TRAN_TYPE_CD = '01' THEN '1'  --他代本
             WHEN (CASE WHEN T1.INTNAL_TRAN_CD ='ZTSA51F02' OR T1.INTNAL_TRAN_CD ='ZTSA51C02' THEN T1.DEPOT_ACCT_ID  --他代本转账出
                        WHEN T1.INTNAL_TRAN_CD ='ZTSA51F08' OR T1.INTNAL_TRAN_CD ='ZTSA51F14' THEN T1.EXPNS_ACCT_ID --他代本转账入
                        WHEN T1.INTNAL_TRAN_CD ='ZTSA50F02' OR T1.INTNAL_TRAN_CD ='ZTSA50C02' THEN T1.DEPOT_ACCT_ID  --本代本、他转账
                        ELSE '' END
                  ) IS NULL THEN '0' --本代本（非转账）
                  END)                                           AS CROSSB_FLG              --19跨行标志
      ,(CASE WHEN T1.INTNAL_TRAN_CD ='ZTSA51F02' OR T1.INTNAL_TRAN_CD ='ZTSA51C02' THEN T1.DEPOT_ACCT_ID --他代本转账出
             WHEN T1.INTNAL_TRAN_CD ='ZTSA51F08' OR T1.INTNAL_TRAN_CD ='ZTSA51F14' THEN T1.EXPNS_ACCT_ID --他代本转账入
             WHEN T1.INTNAL_TRAN_CD ='ZTSA50F02' OR T1.INTNAL_TRAN_CD ='ZTSA50C02' THEN T1.DEPOT_ACCT_ID --本代本、他转账
             ELSE '' END)                                       AS CNTRPTY_ACCT_NUM_ID      --20交易对手账户编号
      ,(CASE WHEN T1.INTNAL_TRAN_CD ='ZTSA51F02' OR T1.INTNAL_TRAN_CD ='ZTSA51C02' THEN T1.DEPOT_ACCT_ID --他代本转账出
             WHEN T1.INTNAL_TRAN_CD ='ZTSA51F08' OR T1.INTNAL_TRAN_CD ='ZTSA51F14' THEN T1.EXPNS_ACCT_ID --他代本转账入
             WHEN T1.INTNAL_TRAN_CD ='ZTSA50F02' OR T1.INTNAL_TRAN_CD ='ZTSA50C02' THEN T1.DEPOT_ACCT_ID --本代本、他转账
             ELSE '' END)                                       AS CNTRPTY_ACCT_NUM         --21交易对手账户名称
      ,(CASE WHEN T1.TRAN_TYPE_CD = '02' THEN '030' --ATM
             WHEN T1.TRAN_TYPE_CD = '03' THEN '032' --柜面
             WHEN T1.TERMN_TYPE_CD ='01' THEN '030' --ATM
             WHEN T1.TERMN_TYPE_CD ='06' THEN '032' --柜面
             --WHEN T1.TERMN_TYPE_CD IN ('03','11','22','23') THEN '031'  --POS
             WHEN TRIM(T1.SEND_ORG_ID) <> '00010344' AND SUBSTR(T1.TRAN_SERV_INPUT_WAY_CD,1,2) IN ('02','90') --A.CHANNELTP !='1' AND
              AND T1.TERMN_TYPE_CD IN ('09','17','23') AND SUBSTR(T1.RESV_REGION,6,1) = '2' THEN '061'  --非标准POS
             WHEN T1.TERMN_TYPE_CD IN ('03','09','11','17','22','23') THEN '031'  --POS
             WHEN T1.TERMN_TYPE_CD ='08' THEN '010' --手机
             WHEN T1.TERMN_TYPE_CD ='07' THEN '020' --电脑
             WHEN T1.TERMN_TYPE_CD ='05' THEN '039' --自助终端
             ELSE '999' --未知
             END)                                               AS PTY_LEG_TYP_CD            --22客户端类型代码
      ,(CASE WHEN T1.CARD_TRAN_TYPE_CD ='1' THEN '0'
             WHEN T1.CARD_TRAN_TYPE_CD ='2' THEN '1'
             WHEN T1.CARD_TRAN_TYPE_CD ='3' THEN '2' --二维码
             WHEN T1.CARD_TRAN_TYPE_CD ='4' THEN '3' --云闪付HCE
             WHEN T1.CARD_TRAN_TYPE_CD ='5' THEN '4' --APPLE-PAY
             WHEN T1.CARD_TRAN_TYPE_CD ='6' THEN '6' --云闪付APP
             WHEN SUBSTR(T1.TRAN_SERV_INPUT_WAY_CD,1,2) IN ('05','95','07','98') THEN '0' --IC卡
             WHEN SUBSTR(T1.TRAN_SERV_INPUT_WAY_CD,1,2) IN ('02','90') THEN '1' --磁条卡
             ELSE '5' --未知,无卡
             END)                                               AS CARD_TXN_TYP_CD           --23卡交易类型代码
      ,(CASE WHEN SUBSTR(T1.TRAN_SERV_INPUT_WAY_CD,1,2) IN ('05','95','07','98') THEN '0' --IC卡
             WHEN SUBSTR(T1.TRAN_SERV_INPUT_WAY_CD,1,2) IN ('02','90')  AND TRIM(T1.SEND_ORG_ID) <> '00010344' THEN '1'--境内磁条卡 AND A.CHANNELTP !='1'
             WHEN SUBSTR(T1.TRAN_SERV_INPUT_WAY_CD,1,2) IN ('02','90') AND SUBSTR(T1.RESV_REGION,7,1) IN ('1','2') AND SUBSTR(T1.RESV_REGION,6,1) IN ('5','6') THEN '0' --境外降级
             ELSE '3' --未知
             END)                                               AS CARD_TYP_CD               --24卡类型代码
      ,'10'                                                     AS BNK_CARD_TYP_CD           --25银行卡类型代码
      ,'1'                                                      AS BNK_CARD_LIQDT_CHN_CD     --26银行卡清算渠道代码
      ,REPLACE(DECODE(T1.MERCHT_CTY_RG_CD,'CHN','',T1.MERCHT_CTY_RG_CD),'@','')
                                                                AS TXN_CTY_PAR               --27交易国家和地区代码 /*MODIFIED BY JCC 20210916 FROM T1.MERCHT_CTY_RG_CD TO NOW FOR CHECK TABLE NO 156 CODE*/
      ,CONCAT(CONCAT(CONCAT(SUBSTR(T1.TRAN_TM,5),TRIM(T1.SYS_FOLLOW_ID)),TRIM(T1.PROC_ORG_ID)),TRIM(T1.SEND_ORG_ID))
                                                                AS CARD_FRAME_ORD_NBR        --28卡组织单号
      ,CASE WHEN T1.TERMN_TYPE_CD IN ('07')  THEN '2' --网络
            ELSE '1' --实体
            END                                                  AS TXN_MERCH_TYP_CD          --29交易商户类型代码
      ,TRIM(T1.PROC_MERCHT_NAME)                                 AS TXN_MERCH_NAME           --30交易商户名称
      ,TRIM(T1.MERCHT_TYPE_CD)                                   AS MERCH_CATEG_NUM          --31商户类别码
      ,(CAST(NVL(
                (
                   CASE WHEN T1.TRAN_TYPE_CD <> '01' THEN T1.TRAN_AMT --本代本、他
                        WHEN TRIM(T1.SEND_ORG_ID) = '00010344' THEN T1.CLEAR_AMT --境外 A.CHANNELTP ='1'
                        ELSE T1.TRAN_AMT --境内
                    END
                ), '0.00') AS NUMBER(18,2)))                     AS LIQDT_AMT               --32清算金额
      ,(CASE WHEN T1.TRAN_TYPE_CD = '01' THEN
                       (
                         CASE WHEN T1.TERMN_TYPE_CD ='01' THEN '02' --他行ATM
                              WHEN T1.TERMN_TYPE_CD ='06' THEN '06' --他行柜面
                              WHEN T1.TERMN_TYPE_CD IN ('03','09','11','17','22','23') THEN '03'  --他行POS
                              WHEN (T1.TERMN_TYPE_CD ='08' OR T1.TERMN_TYPE_CD ='07') THEN '05' --线上无卡
                              ELSE ''
                         END
                       )
             ELSE '01' END)                                     AS UNPAY_CHN_CD              --33银联渠道代码
      ,TRIM(T1.ERR_INFO)                                        AS TXN_RESP_DESC              --34交易返回描述
      ,TRIM(T1.PROC_TERMN_ID)                                   AS TERMN_ID                   --35终端编号
      ,(CASE WHEN T1.TRAN_TYPE_CD <> '01' THEN T1.SEND_ORG_ID
             WHEN TRIM(T1.SEND_ORG_ID) = '00010344' THEN T1.PROC_ORG_ID
             ELSE T1.SEND_ORG_ID --境内
             END)                                               AS ACPT_ORG_CD               --36收单机构代码
      ,TRIM(CONCAT(SUBSTR(T1.TRAN_SERV_INPUT_WAY_CD,1,2),'0'))  AS SRV_PNT_INPUT_MODE_CD     --37服务点输入方式代码
      ,(CASE WHEN SUBSTR(T1.TRAN_SERV_INPUT_WAY_CD,3,1)='1' THEN '1'
             ELSE '0' END)                                      AS PWD_CHECK_FLG             --38密码校验标志
      ,(CASE WHEN TRIM(T1.INIT_SYS_FOLLOW_ID) IS NOT NULL AND TRIM(T1.INIT_TRAN_CD) IS NOT NULL
             THEN 'MPCS'||TRIM(T1.INIT_PROC_ORG_ID)||TRIM(T1.INIT_SEND_ORG_ID)||TRIM(T1.INIT_SYS_FOLLOW_ID)||TO_CHAR(T1.INIT_TRAN_TM,'MMDDHH24MISS')||TRIM(T1.TRAN_TYPE_CD)||TRIM(T1.INIT_TRAN_CD)
             ELSE '' END)                                       AS REV_SEQ_NUM               --39冲正流水号
      ,NULL                                                     AS DEPT_LINE                 --40部门条线
      ,'自助渠道交易流水'                                        AS DATA_SRC                  --41数据来源
      ,TO_CHAR(T1.MIDGROD_TRAN_DT,'YYYY-MM-DD HH24:MI:SS')              AS TRAN_TM                   --42交易时间
     FROM RRP_MDL.O_IML_EVT_ATMP_UNIONPAY_TRAN_FLOW T1--ATMP银联前置交易流水
    WHERE ((T1.TRAN_TYPE_CD <> '01' AND TRIM(T1.TRAN_CD) IS NOT NULL) OR T1.INTNAL_TRAN_CD IS NOT NULL)
      AND T1.INTNAL_TRAN_CD NOT IN ('ZTSA50M02','ZTSA50M03','ZTSA50M04','ZTSA50M05','ZTSA50M06')
      --AND SUBSTR(A.TRANSTIME,7,2) <='59'  --排除分钟不对的数据
      AND T1.TRAN_STATUS_CD NOT IN ('C')           --延时转账冻结会造成重复抽数
      AND T1.JOB_CD = 'mpcsi1'
      AND (
           (TRUNC(T1.MIDGROD_TRAN_DT) = TO_DATE('00010101','YYYYMMDD') AND T1.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
          OR (TRUNC(T1.MIDGROD_TRAN_DT) <> TO_DATE('00010101','YYYYMMDD') AND TRUNC(T1.MIDGROD_TRAN_DT) = TO_DATE(V_P_DATE,'YYYYMMDD'))
      )
      AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');



   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'M_SELF_CHN_TXN_DTL字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
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

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_M_SELF_CHN_TXN_DTL;
/

