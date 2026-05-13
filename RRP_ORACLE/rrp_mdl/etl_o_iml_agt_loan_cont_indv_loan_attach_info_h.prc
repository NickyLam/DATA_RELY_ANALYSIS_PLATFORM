CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H(I_P_DATE IN INTEGER,
                                                                            O_ERRCODE OUT VARCHAR2
                                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H
  *  功能描述：贷款合同个人贷款附属信息历史
  *  创建日期：20230109
  *  开发人员：梅炜
  *  来源表： IML.V_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H
  *  目标表： O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230109  梅炜     首次创建
  *             2    20231108  hulj     优化O层
  *             3    20250610  YJY      剔除删除数据
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-贷款合同个人贷款附属信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H
    (AGT_ID                   --协议编号
    ,CONT_ID                  --合同编号
    ,BUY_CONT_ID              --购房合同编号
    ,HOUSE_FORM_CD            --房屋形式代码
    ,HOUSE_LEVEL_CD           --房屋等级代码
    ,FIR_BUY_FLG              --首次购房标志
    ,HOUSE_WAT_NUM            --房屋权证号
    ,HOUSE_DTL_ADDR           --房屋详细地址
    ,HOUSE_CNT                --房屋套数
    ,HOUSE_TOT_PRICE          --房屋总价
    ,ARCH_AREA                --建筑面积
    ,SET_OF_AREA              --套内面积
    ,ARCH_AREA_PRICE          --建筑面积单价
    ,SET_OF_AREA_PRICE        --套内面积单价
    ,FIRST_PAY_AMT            --首付金额
    ,FIRST_PAY_RATIO          --首付比例
    ,DOWN_PAYMENT_SRC_DESCB   --首付款来源描述
    ,LOAN_RATIO               --贷款比例
    ,ESTIM_PRICE              --评估价格
    ,IDTFY_PRICE              --认定价格
    ,ESTIM_ORG_CERT_NO        --评估机构证件号码
    ,ESTIM_ORG_NAME           --评估机构名称
    ,INT_SUB_FLG              --贴息标志
    ,INT_SUB_RATIO            --贴息比例
    ,CSNER_CERT_NO            --委托人证件号码
    ,CSNER_NAME               --委托人名称
    ,CAP_DIR_CD               --资金投向代码
    ,BUY_INSURE_FLG           --购买保险标志
    ,INSURE_BREED_ID          --保险品种编号
    ,INSU_BENEF_LMT           --保险金额
    ,INSURE_TENOR             --保险期限
    ,PAY_OBJ_NAME             --支付对象名称
    ,SELLER_CORP_CD           --经销商企业代码
    ,SELLER_BUS_LICS_NUM      --经销商营业执照号码
    ,SELLER_CORP_NAME         --经销商企业名称
    ,ESTAT_NAME               --楼盘名称
    ,ARTI_MGMT_FEE_PRICE      --物管费单价
    ,FREE_CLAIM_RAT           --免赔率
    ,GUAR_FLG                 --担保标志
    ,GUAR_TYPE_CD             --担保类型代码
    ,PRESELL_LICS_ID          --预售许可证编号
    ,SELLER_BEAR_REPO_DUTY_FLG  --销售商承担回购责任标志
    ,RELA_AGT_ID              --相关协议书编号
    ,INSU_COMP_NAME           --保险公司名称
    ,INSURE_CONT_ID           --保险合同编号
    ,BUY_ESTATE_TYPE_CD       --所购房产类型代码
    ,BUY_ESTATE_AREA          --所购房产面积
    ,FITMT_TOT_PRICE          --装修总价
    ,COMM_FEE_AMT             --手续费金额
    ,COMM_FEE_MODE_PAY_CD     --手续费支付方式代码
    ,RELA_AGENT_RECD_ID       --关联中介备案编号
    ,SELLER_PS_NAME           --卖房人名称
    ,SELLER_PS_CERT_NO        --卖房人证件号码
    ,REL_ESAT_CERT_ID         --不动产证件编号
    ,CAR_TYPE                 --车型
    ,BUY_CAR_CONT_ID          --购车合同编号
    ,BUY_CARP_DTL_ADDR        --购车位详细地址
    ,CARP_AREA                --车位面积
    ,CAR_TOT_PRICE            --汽车总价
    ,CARP_TOT_PRICE           --车位总价
    ,INDV_OPERING_LOAN_CLS_CD --个人经营性贷款分类代码
    ,OPEN_CORP_STL_ACCT_FLG   --能开立单位结算账户标志
    ,LOC_STRATE_NEW_INDUS_CD  --本地战略性新兴产业代码
    ,ES_ENVI_PROT_CLS_CD      --节能环保分类代码
    ,ENTR_LOAN_RISK_CLS_CD    --委托贷款风险分类代码
    ,ENTR_LOAN_DEP_ACCT_ID    --委托贷款存款账户编号
    ,ENTR_DEP_CURR_CD         --委托存款币种代码
    ,ENTR_DEP_AMT             --委托金额
    ,CAP_SRC_DESCB            --资金来源描述
    ,ENTR_COND_DESCB          --委托条件描述
    ,INDV_LOAN_COMM_FEE_RAT   --个人贷款手续费率
    ,LP_ID                    --法人编号
    ,ESTIM_CERT_TYPE_CD       --评估证件类型代码
    ,ARCH_CORP_NAME           --建筑单位名称
    ,CSNER_CUST_ID            --委托人客户编号
    ,EXPT_LMT_FLG             --例外额度标志
    ,REPAY_ACCT_ID            --还款账户编号
    ,REPAY_ACCT_NAME          --还款账户名称
    ,DEFLT_REPAY_DAY          --默认还款日代码
    ,BAR_FLG                  --随借随还标志
    ,HXB_OPEN_SUPV_ACCT_FLG   --在我行开立监管账户标志
    ,ONL_APV_FLG              --线上审批标志
    ,USE_LMT_FLG              --使用额度标志
    ,HXB_RELA_PARTY_FLG       --我行关联方标志
    ,CHN_ID                   --渠道编号
    ,REPAY_CARD_TYPE_CD       --还款卡类型代码
    ,OPEN_ACCT_BIND_ID_NO     --开户绑定身份证号码
    ,OPEN_ACCT_BIND_MOBILE_NO --开户绑定手机号码
    ,INCRE_CRDT_MODE_CD       --增信模式代码
    ,ACM_CALLBK_AMT           --累计回收金额
    ,FINAL_ENTY_C_NUM         --最终实体卡号
    ,FINAL_ENTY_C_NAME        --最终实体卡名称
    ,FINAL_ENTY_C_OPEN_BANK_NUM   --最终实体卡开户行号
    ,FINAL_ENTY_C_OPEN_BANK_NAME  --最终实体卡开户行名称
    ,FINAL_ENTER_CLEAR_BK_NO      --最终入账账户清算行行号
    ,START_DT                 --开始时间
    ,END_DT                   --结束时间
    ,ID_MARK                  --增删标志
    ,SRC_TABLE_NAME           --源表名称
    ,JOB_CD                   --任务编码
    ,ETL_TIMESTAMP            --ETL处理时间戳
    ,GREEN_CONSM_SUB_TYPE_CD  --绿色消费子类代码
    )
  SELECT 
     AGT_ID                   --协议编号
    ,CONT_ID                  --合同编号
    ,BUY_CONT_ID              --购房合同编号
    ,HOUSE_FORM_CD            --房屋形式代码
    ,HOUSE_LEVEL_CD           --房屋等级代码
    ,FIR_BUY_FLG              --首次购房标志
    ,HOUSE_WAT_NUM            --房屋权证号
    ,HOUSE_DTL_ADDR           --房屋详细地址
    ,HOUSE_CNT                --房屋套数
    ,HOUSE_TOT_PRICE          --房屋总价
    ,ARCH_AREA                --建筑面积
    ,SET_OF_AREA              --套内面积
    ,ARCH_AREA_PRICE          --建筑面积单价
    ,SET_OF_AREA_PRICE        --套内面积单价
    ,FIRST_PAY_AMT            --首付金额
    ,FIRST_PAY_RATIO          --首付比例
    ,DOWN_PAYMENT_SRC_DESCB   --首付款来源描述
    ,LOAN_RATIO               --贷款比例
    ,ESTIM_PRICE              --评估价格
    ,IDTFY_PRICE              --认定价格
    ,ESTIM_ORG_CERT_NO        --评估机构证件号码
    ,ESTIM_ORG_NAME           --评估机构名称
    ,INT_SUB_FLG              --贴息标志
    ,INT_SUB_RATIO            --贴息比例
    ,CSNER_CERT_NO            --委托人证件号码
    ,CSNER_NAME               --委托人名称
    ,CAP_DIR_CD               --资金投向代码
    ,BUY_INSURE_FLG           --购买保险标志
    ,INSURE_BREED_ID          --保险品种编号
    ,INSU_BENEF_LMT           --保险金额
    ,INSURE_TENOR             --保险期限
    ,PAY_OBJ_NAME             --支付对象名称
    ,SELLER_CORP_CD           --经销商企业代码
    ,SELLER_BUS_LICS_NUM      --经销商营业执照号码
    ,SELLER_CORP_NAME         --经销商企业名称
    ,ESTAT_NAME               --楼盘名称
    ,ARTI_MGMT_FEE_PRICE      --物管费单价
    ,FREE_CLAIM_RAT           --免赔率
    ,GUAR_FLG                 --担保标志
    ,GUAR_TYPE_CD             --担保类型代码
    ,PRESELL_LICS_ID          --预售许可证编号
    ,SELLER_BEAR_REPO_DUTY_FLG  --销售商承担回购责任标志
    ,RELA_AGT_ID              --相关协议书编号
    ,INSU_COMP_NAME           --保险公司名称
    ,INSURE_CONT_ID           --保险合同编号
    ,BUY_ESTATE_TYPE_CD       --所购房产类型代码
    ,BUY_ESTATE_AREA          --所购房产面积
    ,FITMT_TOT_PRICE          --装修总价
    ,COMM_FEE_AMT             --手续费金额
    ,COMM_FEE_MODE_PAY_CD     --手续费支付方式代码
    ,RELA_AGENT_RECD_ID       --关联中介备案编号
    ,SELLER_PS_NAME           --卖房人名称
    ,SELLER_PS_CERT_NO        --卖房人证件号码
    ,REL_ESAT_CERT_ID         --不动产证件编号
    ,CAR_TYPE                 --车型
    ,BUY_CAR_CONT_ID          --购车合同编号
    ,BUY_CARP_DTL_ADDR        --购车位详细地址
    ,CARP_AREA                --车位面积
    ,CAR_TOT_PRICE            --汽车总价
    ,CARP_TOT_PRICE           --车位总价
    ,INDV_OPERING_LOAN_CLS_CD --个人经营性贷款分类代码
    ,OPEN_CORP_STL_ACCT_FLG   --能开立单位结算账户标志
    ,LOC_STRATE_NEW_INDUS_CD  --本地战略性新兴产业代码
    ,ES_ENVI_PROT_CLS_CD      --节能环保分类代码
    ,ENTR_LOAN_RISK_CLS_CD    --委托贷款风险分类代码
    ,ENTR_LOAN_DEP_ACCT_ID    --委托贷款存款账户编号
    ,ENTR_DEP_CURR_CD         --委托存款币种代码
    ,ENTR_DEP_AMT             --委托金额
    ,CAP_SRC_DESCB            --资金来源描述
    ,ENTR_COND_DESCB          --委托条件描述
    ,INDV_LOAN_COMM_FEE_RAT   --个人贷款手续费率
    ,LP_ID                    --法人编号
    ,ESTIM_CERT_TYPE_CD       --评估证件类型代码
    ,ARCH_CORP_NAME           --建筑单位名称
    ,CSNER_CUST_ID            --委托人客户编号
    ,EXPT_LMT_FLG             --例外额度标志
    ,REPAY_ACCT_ID            --还款账户编号
    ,REPAY_ACCT_NAME          --还款账户名称
    ,DEFLT_REPAY_DAY          --默认还款日代码
    ,BAR_FLG                  --随借随还标志
    ,HXB_OPEN_SUPV_ACCT_FLG   --在我行开立监管账户标志
    ,ONL_APV_FLG              --线上审批标志
    ,USE_LMT_FLG              --使用额度标志
    ,HXB_RELA_PARTY_FLG       --我行关联方标志
    ,CHN_ID                   --渠道编号
    ,REPAY_CARD_TYPE_CD       --还款卡类型代码
    ,OPEN_ACCT_BIND_ID_NO     --开户绑定身份证号码
    ,OPEN_ACCT_BIND_MOBILE_NO --开户绑定手机号码
    ,INCRE_CRDT_MODE_CD       --增信模式代码
    ,ACM_CALLBK_AMT           --累计回收金额
    ,FINAL_ENTY_C_NUM         --最终实体卡号
    ,FINAL_ENTY_C_NAME        --最终实体卡名称
    ,FINAL_ENTY_C_OPEN_BANK_NUM   --最终实体卡开户行号
    ,FINAL_ENTY_C_OPEN_BANK_NAME  --最终实体卡开户行名称
    ,FINAL_ENTER_CLEAR_BK_NO      --最终入账账户清算行行号
    ,START_DT                 --开始时间
    ,END_DT                   --结束时间
    ,ID_MARK                  --增删标志
    ,SRC_TABLE_NAME           --源表名称
    ,JOB_CD                   --任务编码
    ,ETL_TIMESTAMP            --ETL处理时间戳
    ,GREEN_CONSM_SUB_TYPE_CD  --绿色消费子类代码
    FROM IML.V_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H  --视图-贷款合同个人贷款附属信息历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';  --MOD BY YJY 20250610

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H','', O_ERRCODE);

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

END ETL_O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H;
/

