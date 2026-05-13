CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IFRS_FCT_ECL_RES_LAW(I_P_DATE IN INTEGER,
                                                              O_ERRCODE OUT VARCHAR2
                                                              )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IFRS_FCT_ECL_RES_LAW
  *  功能描述：减值系统诉讼费表
  *  创建日期：20250526
  *  开发人员：YJY
  *  来源表：IOL.V_IFRS_FCT_ECL_RES_LAW
  *  目标表：O_IOL_IFRS_FCT_ECL_RES_LAW
  *  配置表：
  *  修改情况：序号  修改日期  修改人    修改原因
  *             1    20250526  YJY     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_P_DATE2    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(200);              --分区名
  V_PART_NAME_2 VARCHAR2(200);            --分区名2
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(100):= 'O_IOL_IFRS_FCT_ECL_RES_LAW'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IFRS_FCT_ECL_RES_LAW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_P_DATE2 := TO_CHAR(TO_DATE(V_P_DATE ,'YYYYMMDD') + 1 , 'YYYYMMDD'); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_PART_NAME_2 := 'PARTITION_'||V_P_DATE2;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --分区表的重跑处理
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);
  ETL_PARTITION_ADD(V_P_DATE2, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME_2);
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-减值系统诉讼费表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_LAW
  (   D_DATE_DT             --数据日期
     ,N_ASSET_CLASS_CD      --敞口代码
     ,V_ID_NUMBER           --借据号
     ,V_CUST_CD             --客户名
     ,V_CUST_NAME           --客户号
     ,V_PD_INTERNAL         --PD模型
     ,V_REGUL_CLASSIF_CD    --五级分类
     ,V_INTERNAL_RATING     --内部评级
     ,V_ISSUER_RATING       --发行人评级
     ,V_OBLIGATION_RATING   --债项评级
     ,N_ODUS_DAYS           --逾期天数
     ,N_PHASE_DIVISION_CD   --阶段划分
     ,N_CUR                 --余额
     ,N_INT                 --利息
     ,N_SLOW                --缓释品金额
     ,N_EAD_FIN             --EAD
     ,N_PD                  --PD
     ,N_LGD_FIN             --LGD
     ,N_ECL                 --ECL
     ,V_THREE_STAGE_CD      --三分类
     ,V_PRODUCK_TYPE_CD     --产品大类
     ,V_PRODUCK_TYPE_S_CD   --产品小类
     ,V_CCY_CD              --币种(CNY)
     ,D_ACCT_OPEN_DATE      --起息日
     ,D_ACCT_EXPIRE_DATE    --到期日
     ,N_RESIDUAL_MATURITY   --剩余期限
     ,N_ODUE_DAYS_CUR       --本金逾期天数
     ,N_ODUE_DAYS_INT       --利息逾期天数
     ,V_BLICK               --铁骑清单
     ,V_SUB_CD              --科目号
     ,V_SUB_NAME            --科目名称
     ,V_ORG_CD              --机构号
     ,V_ORG_NAME            --机构名称
     ,BEFORE_ADJUSTMENT_COEFFICIENT --输入系数
     ,BEFORE_N_ADJUSTMENT_ECL       --调整后的ECL
     ,N_EAD_FIN_BEFORE      --原币EAD
     ,N_ECL_BEFORE          --原币ECL
     ,V_CCY_CD_BEFORE       --原币币种
     ,N_CUR_BEFORE          --原币本金余额
     ,N_INT_BEFORE          --原币利息
     ,N_SLOW_BEFORE         --原币缓释品金额
     ,V_AROUND_SIGN         --表内外标识
     ,V_INVEST_INDUST_CD    --国际行业
     ,N_LGD_BEFORE          --基础LGD
     ,V_ACCOUNT_AGEING      --账龄
     ,V_DFC_ECL_CD          --调整后：’DCF‘ 未调整： ’ECL‘
     ,INDUSTRY_NAME         --国际行业（报表用）
     ,N_ECL_DCF             --DCF调整后的ECL
     ,N_ECL_BEFORE_DCF      --DCF调整后的原币ECL
     ,ISSUE_BANK_CN_NAME    --开证行
     ,RATE_FIN              --最终评级
     ,V_FINANCIAL_ID        --金融工具表编号
     ,V_BOND_ID             --债券编号
     ,V_FORECAST_MOD        --旧版模型分组 预测用
     ,V_BILL_NO             --汇票号
     ,EXECU_ORG_NO          --经办机构
     ,EXECU_ORG_NAME        --经办机构名称
     ,N_PV_VARIATION        --公允价值变动_折人民币
     ,N_BALANCE_FACE        --面值_展示
     ,N_INT_ADJ_BAL         --利息调整_展示
     ,N_INT_RECEIVABLE      --应收利息_展示
     ,N_INT_ACCRUED         --应计利息_展示
     ,FIN_INSTM_NAME        --金融工具名称
     ,ASSET_TYPE_NAME       --产品分类
     ,GUARTOR_CUST_NAME     --担保客户名称
     ,V_VALUE_MODEL_NAME    --估值模型名称
     ,PV_VARIATION          --原币公允价值
     ,INTNAL_SECU_ACCT_ID   --内部证券账户编号
     ,N_PV_VARIATION_LASTDAY   --前一天公允价值变动_折人民币
     ,PV_VARIATION_LASTDAY     --前一天公允价值变动_原币
     ,V_SERIALNO            --减值借据号_物理展示
     ,BIZ_NO                --贴现转贴现主键
     ,LEVEL5_CLASS_CD       --五级分类代码
     ,PRODUCT_NO            --产品编码
     ,V_TX_CUST_NAME        --票据贴现人
     ,V_GROUP_CUST_NO       --集团客户号
     ,V_GROUP_CUST_NAME     --集团客户名
     ,BILL_NO               --票据编号
     ,BILL_SUB_INTRV_ID     --子票据区间编号
     ,GLOB_SEQ_NUM          --全局流水号
     ,UNIQUE_SEQ_NUM        --业务流水号
     ,TAX_ECL               --垫付增值税ECL
     ,TAX_ECL_BEFORE        --垫付增值税原币ECL
     ,TAX_BALANCE_BEFORE    --垫付增值税原币余额
     ,TAX_BALANCE           --垫付增值税余额
     ,TOTAL_ECL             --ECL汇总
     ,TOTAL_ECL_BEFORE      --原币ECL汇总
     ,MARKET_TYPE_ID        --交易市场编号
     ,SEPARATE_CODE         --分池代码
     ,V_PD_MODE             --PD新模型名称
     ,N_CUR_EAD             --本金EAD
     ,N_INT_EAD             --利息EAD
     ,N_OFF_EAD             --表外EAD
     ,N_CUR_ECL             --本金ECL
     ,N_INT_ECL             --利息ECL
     ,N_OFF_ECL             --表外ECL
     ,BOND_ITEM_NO          --借据号（获取押品使用）
     ,ADD_PD_MUL_LGD        --管理层叠加PD*LGD
     ,BEFORE_PD_MUL_LGD     --管理层叠加前PD
     ,BEFORE_ECL            --管理层叠加前ECL
     ,ADD_ECL               --管理层叠加后ECL
     ,ADD_N_CUR_ECL         --管理层叠加后本金ECL
     ,BEFORE_N_CUR_ECL      --管理层叠加前本金ECL
     ,ADD_N_INT_ECL         --管理层叠加后利息ECL
     ,BEFORE_N_INT_ECL      --管理层叠加前利息ECL
     ,ADD_N_OFF_ECL         --管理层叠加后表外ECL
     ,BEFORE_N_OFF_ECL      --管理层叠加前表外ECL
     ,ADD_N_PD              --管理层叠加N_PD
     ,BEFORE_N_PD           --管理层叠加前N_PD
     ,RECVBL_UNCOL_INT      --应收未收利息
     ,RECVBL_UNCOL_INT_ECL  --应收未收利息ECL
     ,INT_RECVBL_ECL        --应收利息ECL
     ,N_INT_ACCRUED_ECL     --应计利息ECL
     ,LAW_ECL               --代垫诉讼费ECL
     ,LAW_ECL_BEFORE        --代垫诉讼费原币ECL
     ,LAW_BALANCE_BEFORE    --代垫诉讼费原币余额
     ,LAW_BALANCE           --代垫诉讼费本币余额
     ,N_INT_RECEIVABLE_BEFORE    --应收利息原币
     ,RECVBL_UNCOL_INT_BEFORE    --应收未收利息原币
     ,N_INT_ACCRUED_BEFORE       --应计利息原币
     ,N_INT_RECEIVABLE_ECL_BEFORE  --应收利息ECL原币
     ,RECVBL_UNCOL_INT_ECL_BEFORE  --应收未收利息ECL原币
     ,N_INT_ACCRUED_ECL_BEFORE     --应计利息ECL原币
     ,EXEC_INT_RATE         --执行利率
     ,REMARK                --备注
     ,EDIT_ECL              --预期信用损失ECL_审计调整
     ,EDIT_PHASE_DIVISION   --阶段划分_审计调整
     ,EDIT_REGUL_CLASSIF_CD --五级分类_审计调整
     ,EDIT_THREE_STAGE_CD   --三分类_审计调整
     ,V_BOOK_VAL            --账面价值
     ,ETL_DT                --ETL处理日期
     ,ETL_TIMESTAMP         --ETL处理时间戳
    )
  SELECT
      CASE WHEN SUBSTR(TO_CHAR(D_DATE_DT,'YYYYMMDD'),5) = '1231'
            AND SUBSTR(V_P_DATE,5) = '1231'
           THEN D_DATE_DT
           ELSE D_DATE_DT + 1
      END  AS D_DATE_DT     --数据日期    MOD BY YJY 20250526 减值的日期是对ETL_DT+1
     ,N_ASSET_CLASS_CD      --敞口代码
     ,V_ID_NUMBER           --借据号
     ,V_CUST_CD             --客户名
     ,V_CUST_NAME           --客户号
     ,V_PD_INTERNAL         --PD模型
     ,V_REGUL_CLASSIF_CD    --五级分类
     ,V_INTERNAL_RATING     --内部评级
     ,V_ISSUER_RATING       --发行人评级
     ,V_OBLIGATION_RATING   --债项评级
     ,N_ODUS_DAYS           --逾期天数
     ,N_PHASE_DIVISION_CD   --阶段划分
     ,N_CUR                 --余额
     ,N_INT                 --利息
     ,N_SLOW                --缓释品金额
     ,N_EAD_FIN             --EAD
     ,N_PD                  --PD
     ,N_LGD_FIN             --LGD
     ,N_ECL                 --ECL
     ,V_THREE_STAGE_CD      --三分类
     ,V_PRODUCK_TYPE_CD     --产品大类
     ,V_PRODUCK_TYPE_S_CD   --产品小类
     ,V_CCY_CD              --币种(CNY)
     ,D_ACCT_OPEN_DATE      --起息日
     ,D_ACCT_EXPIRE_DATE    --到期日
     ,N_RESIDUAL_MATURITY   --剩余期限
     ,N_ODUE_DAYS_CUR       --本金逾期天数
     ,N_ODUE_DAYS_INT       --利息逾期天数
     ,V_BLICK               --铁骑清单
     ,V_SUB_CD              --科目号
     ,V_SUB_NAME            --科目名称
     ,V_ORG_CD              --机构号
     ,V_ORG_NAME            --机构名称
     ,BEFORE_ADJUSTMENT_COEFFICIENT --输入系数
     ,BEFORE_N_ADJUSTMENT_ECL       --调整后的ECL
     ,N_EAD_FIN_BEFORE      --原币EAD
     ,N_ECL_BEFORE          --原币ECL
     ,V_CCY_CD_BEFORE       --原币币种
     ,N_CUR_BEFORE          --原币本金余额
     ,N_INT_BEFORE          --原币利息
     ,N_SLOW_BEFORE         --原币缓释品金额
     ,V_AROUND_SIGN         --表内外标识
     ,V_INVEST_INDUST_CD    --国际行业
     ,N_LGD_BEFORE          --基础LGD
     ,V_ACCOUNT_AGEING      --账龄
     ,V_DFC_ECL_CD          --调整后：’DCF‘ 未调整： ’ECL‘
     ,INDUSTRY_NAME         --国际行业（报表用）
     ,N_ECL_DCF             --DCF调整后的ECL
     ,N_ECL_BEFORE_DCF      --DCF调整后的原币ECL
     ,ISSUE_BANK_CN_NAME    --开证行
     ,RATE_FIN              --最终评级
     ,V_FINANCIAL_ID        --金融工具表编号
     ,V_BOND_ID             --债券编号
     ,V_FORECAST_MOD        --旧版模型分组 预测用
     ,V_BILL_NO             --汇票号
     ,EXECU_ORG_NO          --经办机构
     ,EXECU_ORG_NAME        --经办机构名称
     ,N_PV_VARIATION        --公允价值变动_折人民币
     ,N_BALANCE_FACE        --面值_展示
     ,N_INT_ADJ_BAL         --利息调整_展示
     ,N_INT_RECEIVABLE      --应收利息_展示
     ,N_INT_ACCRUED         --应计利息_展示
     ,FIN_INSTM_NAME        --金融工具名称
     ,ASSET_TYPE_NAME       --产品分类
     ,GUARTOR_CUST_NAME     --担保客户名称
     ,V_VALUE_MODEL_NAME    --估值模型名称
     ,PV_VARIATION          --原币公允价值
     ,INTNAL_SECU_ACCT_ID   --内部证券账户编号
     ,N_PV_VARIATION_LASTDAY   --前一天公允价值变动_折人民币
     ,PV_VARIATION_LASTDAY     --前一天公允价值变动_原币
     ,V_SERIALNO            --减值借据号_物理展示
     ,BIZ_NO                --贴现转贴现主键
     ,LEVEL5_CLASS_CD       --五级分类代码
     ,PRODUCT_NO            --产品编码
     ,V_TX_CUST_NAME        --票据贴现人
     ,V_GROUP_CUST_NO       --集团客户号
     ,V_GROUP_CUST_NAME     --集团客户名
     ,BILL_NO               --票据编号
     ,BILL_SUB_INTRV_ID     --子票据区间编号
     ,GLOB_SEQ_NUM          --全局流水号
     ,UNIQUE_SEQ_NUM        --业务流水号
     ,TAX_ECL               --垫付增值税ECL
     ,TAX_ECL_BEFORE        --垫付增值税原币ECL
     ,TAX_BALANCE_BEFORE    --垫付增值税原币余额
     ,TAX_BALANCE           --垫付增值税余额
     ,TOTAL_ECL             --ECL汇总
     ,TOTAL_ECL_BEFORE      --原币ECL汇总
     ,MARKET_TYPE_ID        --交易市场编号
     ,SEPARATE_CODE         --分池代码
     ,V_PD_MODE             --PD新模型名称
     ,N_CUR_EAD             --本金EAD
     ,N_INT_EAD             --利息EAD
     ,N_OFF_EAD             --表外EAD
     ,N_CUR_ECL             --本金ECL
     ,N_INT_ECL             --利息ECL
     ,N_OFF_ECL             --表外ECL
     ,BOND_ITEM_NO          --借据号（获取押品使用）
     ,ADD_PD_MUL_LGD        --管理层叠加PD*LGD
     ,BEFORE_PD_MUL_LGD     --管理层叠加前PD
     ,BEFORE_ECL            --管理层叠加前ECL
     ,ADD_ECL               --管理层叠加后ECL
     ,ADD_N_CUR_ECL         --管理层叠加后本金ECL
     ,BEFORE_N_CUR_ECL      --管理层叠加前本金ECL
     ,ADD_N_INT_ECL         --管理层叠加后利息ECL
     ,BEFORE_N_INT_ECL      --管理层叠加前利息ECL
     ,ADD_N_OFF_ECL         --管理层叠加后表外ECL
     ,BEFORE_N_OFF_ECL      --管理层叠加前表外ECL
     ,ADD_N_PD              --管理层叠加N_PD
     ,BEFORE_N_PD           --管理层叠加前N_PD
     ,RECVBL_UNCOL_INT      --应收未收利息
     ,RECVBL_UNCOL_INT_ECL  --应收未收利息ECL
     ,INT_RECVBL_ECL        --应收利息ECL
     ,N_INT_ACCRUED_ECL     --应计利息ECL
     ,LAW_ECL               --代垫诉讼费ECL
     ,LAW_ECL_BEFORE        --代垫诉讼费原币ECL
     ,LAW_BALANCE_BEFORE    --代垫诉讼费原币余额
     ,LAW_BALANCE           --代垫诉讼费本币余额
     ,N_INT_RECEIVABLE_BEFORE    --应收利息原币
     ,RECVBL_UNCOL_INT_BEFORE    --应收未收利息原币
     ,N_INT_ACCRUED_BEFORE       --应计利息原币
     ,N_INT_RECEIVABLE_ECL_BEFORE  --应收利息ECL原币
     ,RECVBL_UNCOL_INT_ECL_BEFORE  --应收未收利息ECL原币
     ,N_INT_ACCRUED_ECL_BEFORE     --应计利息ECL原币
     ,EXEC_INT_RATE         --执行利率
     ,REMARK                --备注
     ,EDIT_ECL              --预期信用损失ECL_审计调整
     ,EDIT_PHASE_DIVISION   --阶段划分_审计调整
     ,EDIT_REGUL_CLASSIF_CD --五级分类_审计调整
     ,EDIT_THREE_STAGE_CD   --三分类_审计调整
     ,V_BOOK_VAL            --账面价值
     ,CASE WHEN SUBSTR(TO_CHAR(D_DATE_DT,'YYYYMMDD'),5) = '1231'
           THEN D_DATE_DT
           ELSE D_DATE_DT + 1
       END   AS ETL_DT      --ETL处理日期  MOD BY YJY 20250526 减值的日期是对ETL_DT+1
     ,ETL_TIMESTAMP         --ETL处理时间戳
    FROM IOL.V_IFRS_FCT_ECL_RES_LAW --视图-减值系统诉讼费表
   WHERE D_DATE_DT = CASE WHEN SUBSTR(V_P_DATE,5) = '1231'
                          THEN TO_DATE(V_P_DATE,'YYYYMMDD')
                          ELSE TO_DATE(V_P_DATE,'YYYYMMDD') - 1
                     END
      OR D_DATE_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
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
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_IFRS_FCT_ECL_RES_LAW;
/

