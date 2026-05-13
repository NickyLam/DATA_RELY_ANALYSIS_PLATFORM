CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_ACCT_LOAN
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_ACCT_LOAN
  *  功能描述：对公_账务基表
  *  创建日期：20221103
  *  开发人员：韦永钊
  *  来源表：
  *  目标表：A_FGB_ACCT_LOAN --对公_账务基表
  *  配置表：CODE_MAP
  *  修改情况：
  *  序号  修改日期   修改人            修改原因
  *  001   20221103   weiyongzhao       创建过程
  *  002   20230217   liuyu             优化字段，五大产业多余的字段删除
  *  003   20230523   liuyu             根据测试情况 调整表外所属门类映射逻辑
  *  004   20230525   liuyu             根据测试情况 调整表外经办机构编号
  *  005   20230529   liuyu             表外五级分类改从借据表出
  *  006   20230530   liuyu             LOAN_DIR_BIO_FLG 借据资金使用位置是否境内外区分境内外借据 1104口径
  *  007   20230625   MW                修改循环贷筛选逻辑
  *  008   20230713   MW                对公账务剔除个体工商户
  *  009   20230822   lwb               调整TXSZJJHXCYDLMC投向数字经济核心产业大类名称字段的逻辑
  *  100   20230908   HYF               调整投向高技术制造业大类名称逻辑
  *  101   20240125   HYF               投向数字经济核心产业中类新增码值05 数字化效率提升业
  *  102   20240220   YJY               调整”是否专精特新中小企业；新增”是否监管名单中的专精特新中小企业”
  *  103   20240220   YJY               新增"是否养老产业"
  *  104   20240226   YJY               新增"是否投向政府和社会资本合作（PPP）项目","是否新机制发放贷款"
  *  105   20240624   HYF               修改投向数字经济核心产业大类名称直取补录
  *  106   20251231   HYF               修改五大产业指标逻辑，从S_LOAN出数，不从补录表，补录表缺失微业贷数据
  *  107   20260320   HYF               新增并购贷款类型、是否境外并购贷款、是否退役军人创办企业、放款月企业规模、放款月控股类型
  *  108   20260330   HYF               调整重组贷款标识逻辑
  ************************************************************************/
  /*ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXWHJXGCYXL;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFTXJNHBML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFTXXYDXXJSML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFTXSWML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFTXGDZBZZML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFTXXNYML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFTXXCLML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFTXXNYQCML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFTXSZCYML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFTXXGFWML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXGJSZZYDL;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXSZJJHXCYDL;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXZSCQMJXCYDL;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXZSCQMJXCYDLMC;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXGJSZZY;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXGJSZZYMC;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN ZLXXXCYLB;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXSZJJHXCYXL;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXZLXXXCYML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXGTJCYXL;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXZSCQMJXCYXL;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXGJSCYML;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFWHCY;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN CNLB;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN TXZLXXXCYXL;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFYYP;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN SFYBZ;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN ZJLYDM;
ALTER TABLE A_FGB_ACCT_LOAN DROP COLUMN ZJLY;*/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_ACCT_LOAN';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR(I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写

  V_TAB_NAME := 'A_FGB_ACCT_LOAN'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期
  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(I_P_DATE, 'A_FGB_ACCT_LOAN', '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '表内贷款_插入主表';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND*/ INTO RRP_MDL.A_FGB_ACCT_LOAN NOLOGGING
    (
          BGRQ                      --001 报告日期
         ,JYWYM                     --002 交易唯一码
         ,ZHWYM                     --003 账户唯一码
         ,JBJGSZXZQHDM              --004 经办机构机构所在行政区划代码
         ,JBJGMC                    --005 经办机构名称
         ,ZWJGSZXZQHDM              --006 账务机构机构所在行政区划代码
         ,ZWJGBH                    --007 账务机构编号
         ,ZWJGMC                    --008 账务机构名称
         ,BNW                       --009 表内外
         ,TJYWPZ                    --010 统计业务品种
         ,TJYWPZMC                  --011 统计业务品种名称
         ,DKYWPZ                    --012 贷款业务品种
         ,DKYWPZMC                  --013 贷款业务品种名称
         ,BWYWLB                    --014 表外业务类别
         ,SXYWLB                    --015 授信业务类别
         ,KJKMDM                    --016 会计科目代码
         ,KJKMMC                    --017 会计科目名称
         ,KHWYM                     --018 客户唯一码
         ,TJKHLB                    --019 统计客户类别
         ,KHMC                      --020 客户名称
         ,WJFL                      --021 五级分类
         ,WJFLMC                    --022 五级分类名称
         ,SFBL                      --023 是否不良
         ,TJYE                      --024 统计余额（元）
         ,DAIKLB                    --025 贷款类别
         ,DIANKLB                   --026 垫款类别
         ,BZ                        --027 币种
         ,BZLB                      --028 币种类别
         ,YSQSRQ                    --029 原始起始日期
         ,YSDQRQ                    --030 原始到期日期
         ,YSQXQJ                    --031 原始期限区间
         ,YSQXQJMC                  --032 原始期限区间名称
         ,BJZZYQRQ                  --033 本金最早逾期日期
         ,ZZYQRQ                    --034 最早逾期日期
         ,TJYQTS                    --035 统计逾期天数（天）
         ,YQTSQJ                    --036 逾期天数区间
         ,YQTSQJMC                  --037 逾期天数区间名称
         ,DKPZ                      --038 贷款品种
         ,SFTXGJSCY                 --039 是否投向高技术产业
         ,TXGJSCYMLMC               --041 投向高技术产业门类名称
         ,ZQDQRQ                    --042 展期到期日期
         ,SFZQ                      --043 是否展期
         ,SFBGDK                    --044 是否并购贷款
         ,SFJWBGDK                  --045 是否境外并购贷款
         ,FKJE                      --046 放款金额（元）
         ,ZXLL                      --047 执行利率（年）
         ,NHLXSY                    --048 年化利息收益（元）
         ,SSGMJJHYMLMC              --049 所属国民经济行业门类名称
         ,TXGMJJXYMLMC              --050 投向国民经济行业门类名称
         ,TXGMJJXYDLMC              --051 投向国民经济行业大类名称
         ,TXGMJJXYZLMC              --052 投向国民经济行业中类名称
         ,TXGMJJXYXLMC              --053 投向国民经济行业小类名称
         ,TXGMJJXYXLDM              --054 投向国民经济行业小类代码
         ,SFGYQYJSGZSJDK            --057 是否工业企业技术改造升级贷款
         ,ZLXXXCYLBMC               --059 战略性新兴产业类别名称
         ,TXSFJW                    --061 投向是否境外
         ,SFTXWHCYDL                --065 是否投向文化产业大类
         ,TJXWQYLBMC                --077 统计小微企业类别名称
         ,QYCZRJJCFZLMC             --078 企业出资人经济成分中类名称
         ,SXZED                     --079 授信总额度（元）
         ,SFPHXWQY                  --080 是否普惠小微企业
         ,TJDBFS                    --081 统计担保方式
         ,TJDBFSMC                  --082 统计担保方式名称
         ,DBFSNBKJ                  --083 担保方式内部口径
         ,ZDBFSDM                   --084 主担保方式代码
         ,ZDBFS                     --085 主担保方式
         ,SFFDB                     --086 是否反担保
         ,SFGXRBZ                   --087 是否关系人保证
         ,SFFRZHTZ                  --088 是否法人账户透支
         ,SFWHBXD                   --089 是否无还本续贷
         ,SFXHD                     --090 是否循环贷
         ,HPCDFLB                   --091 汇票承兑方类别
         ,HPCDFLBMC                 --092 汇票承兑方类别名称
         ,SFYSHZ                    --093 是否银税合作
         ,SFZJTXZXQY                --094 是否专精特新中小企业
         ,SFGTQY                    --095 是否关停企业
         ,BZXAJGCLB                 --096 保障性安居工程类别
         ,SDRQ                      --097 首贷日期
         ,SFZXSBDK                  --098 是否征信首笔贷款
         ,JJDKZT                    --099 借据贷款状态
         ,CLDKZT                    --100 存量贷款状态
         ,DKCZFCFS                  --101 贷款财政扶持方式
         ,SFNYCYHLTQY               --102 是否农业产业化龙头企业
         ,SFYQ                      --103 是否延期
         ,SFWLCZGSCP                --104 是否为理财子公司产品
         ,DKYT                      --109 贷款用途
         ,JJFKJEZW                  --110 借据放款金额折人民币（万元）
         ,JJYEZW                    --111 借据余额折人民币净值（万元）
         ,QX                        --112 欠息
         ,FAX                       --113 罚息
         ,FUX                       --114 复息
         ,HTYE                      --115 合同余额（原币种）
         ,FSLXDM                    --116 发生类型代码
         ,FSLX                      --117 发生类型
         ,YHTBH                     --118 原合同编号
         ,SFCZ                      --119 是否重组
         ,CZRQ                      --120 重组日期
         ,YSQXLB                    --121 原始期限类别
         ,YSQXLBMC                  --122 原始期限类别名称
         ,QYCZRJJCFZL               --123 企业出资人经济成分中类
         ,TJYQBJJE                  --124 统计逾期本金金额（元）
         ,TXGJSZZYDLMC              --126 投向高技术制造业大类名称
         ,TXSZJJHXCYDLMC            --128 投向数字经济核心产业大类名称
         ,DEPARTMENTD               --129 归属部门
         ,SFTXZSCQMJXCY             --132 是否投向知识产权密集型产业
         ,PJBH                      --133 票据编号
         ,KHZBKHJLH                 --134 客户主办客户经理号
         ,KHZBGYH                   --135 客户主办柜员号
         ,KHZBKHJLMC                --136 客户主办客户经理名称
         ,KHZBKHJLSSJG              --137 客户主办客户经理所属机构
         ,JJZBKHJLH                 --138 借据主办客户经理号
         ,JJZBGYH                   --139 借据主办柜员号
         ,JJZBKHJLMC                --140 借据主办客户经理名称
         ,JJZBKHJLSSJG              --141 借据主办客户经理所属机构
         ,YQBJJE                    --142 逾期本金金额(元)
         ,JBJGBH                    --143 经办机构编号
         ,DRMBZSL                   --144 对人民币折算率
         ,JJYE_YBZ                  --145 借据余额（原币值）
         ,FKJE_YBZ                  --146 放款金额（原币值）
         ,SSGMJJHYDLMC              --147 所属国民经济行业大类名称
         ,SSGMJJHYZLMC              --148 所属国民经济行业中类名称
         ,SSGMJJHYXLMC              --149 所属国民经济行业小类名称
         ,QYCZRJJCFXLMC             --150 企业出资人经济成分小类名称
         ,ZTJJH                     --155 转贴现对应直贴借据号
         ,SFJGMDZDZJTXZXQY          --156 是否监管名单中的专精特新中小企业
         ,SFYLCY                    --157 是否养老产业
         ,SFTXZFHSHZBHZ_PPP_XM      --158 是否投向政府和社会资本合作（PPP）项目
         ,SFXJZFFDK                 --159 是否新机制发放贷款
         ,BGDKLX                    --160 并购贷款类型
         ,SFTYJRCBQY                --161 是否退役军人创办企业
         ,FKSQYGM                   --162 放款时企业规模
         ,FKSKGLX                   --163 放款时控股类型
         ,FKYQYGM                   --164 放款月企业规模
         ,FKYKGLX                   --165 放款月控股类型
    )
  WITH LOAN_DIR_IDY_TMP AS ( -- 五大产业临时表
  SELECT T1.RCPT_ID
        ,T1.LOAN_DIR_IDY
        -- S72 --表内外都要判断
        ,NVL(M7.TAR_VALUE_NAME,'不适用')       AS TXGJSZZYDLMC --投向高技术制造业大类
        -- G0107 -- 从补录表出
        --,DECODE(Z.SFTXGJSCY,'Y','是','否')     AS SFTXGJSCY --是否投向高技术产业
        ,DECODE(T1.HIGH_TECH_FLG,'Y','是','否')     AS SFTXGJSCY --是否投向高技术产业 MOD BY 20251230
/*        ,CASE WHEN Z.SFTXGJSCY = 'Y' 
              THEN DECODE(F.CYML,'服务业','高技术服务业'
                                ,'制造业','高技术制造业'
                                ,'不适用')
              ELSE '不适用'
         END                                   AS TXGJSCYMLMC --投向高技术产业门类*/
        ,CASE WHEN T1.HIGH_TECH_IDY_MFG_CL IN ('01','02','03','04','05','06') THEN '高技术制造业'
              WHEN T1.HIGH_TECH_IDY_SER_FLG = 'Y' THEN '高技术服务业'
         ELSE '不适用' END                AS TXGJSCYMLMC --投向高技术产业门类  MOD BY 20251230     
        --,Z.TXSZJJHXCYZL                        AS TXSZJJHXCYDLMC --投向数字经济核心产业大类名称  modify by lwb 20230822
        ,CASE T1.DIGI_ECON_CORE_IDY
               WHEN '01' THEN '数字产品制造业' --数字产品制造业
               WHEN '02' THEN '数字产品服务业' --数字产品服务业
               WHEN '03' THEN '数字技术应用业' --数字技术应用业
               WHEN '04' THEN '数字要素驱动业' --数字要素驱动业
               WHEN '05' THEN '数字化效率提升业' --数字化效率提升业
               ELSE '不适用' 
         END                              AS TXSZJJHXCYDLMC --投向数字经济核心产业大类名称  MOD BY 20251230
        --,DECODE(Z.SFTXZSCQMJXCY,'Y','是','否') AS SFTXZSCQMJXCY--是否投向知识产权密集型产业
        ,DECODE(T1.IP_CONC_IDY,'Y','是','否') AS SFTXZSCQMJXCY--是否投向知识产权密集型产业 MOD BY 20251230
        --G19 -- 从补录表出
/*        ,DECODE(Z.TXZLXXXCYML,'C','节能环保产业' --节能环保
                             ,'D','新一代信息技术产业' --新一代信息技术
                             ,'E','生物产业' --生物
                             ,'F','高端装备制造产业' --高端装备制造
                             ,'G','新能源产业' --新能源
                             ,'H','新材料产业' --新材料
                             ,'I','新能源汽车产业' --新能源汽车
                             ,'J','数字创意产业' --数字创意
                             ,'K','相关服务产业' --相关服务
                             ,'不适用')        AS ZLXXXCYLBMC -- 战略性新兴产业类别名称
         -- 补录表提数脚本用的TXZLXXXCYML,所以按照这个字段取类别名称*/
        ,DECODE(T1.STRTG_EMER_IDY_TYP,'C','节能环保产业' --节能环保
                             ,'D','新一代信息技术产业' --新一代信息技术
                             ,'E','生物产业' --生物
                             ,'F','高端装备制造产业' --高端装备制造
                             ,'G','新能源产业' --新能源
                             ,'H','新材料产业' --新材料
                             ,'I','新能源汽车产业' --新能源汽车
                             ,'J','数字创意产业' --数字创意
                             ,'K','相关服务产业' --相关服务
                             ,'不适用')        AS ZLXXXCYLBMC -- 战略性新兴产业类别名称 MOD BY 20251230
        --,DECODE(Z.SFTXWHCYDL,'Y','是','否')    AS SFTXWHCYDL --是否投向文化产业大类
        ,DECODE(T1.CUL_PROPERTY_FLG,'Y','是','否')  AS SFTXWHCYDL --是否投向文化产业大类 MOD BY 20251230
       -- ,DECODE(Z.SFGYQYJSGZSJDK,'Y','是','否') AS SFGYQYJSGZSJDK --是否工业企业技术改造升级项目
        ,DECODE(T1.IDY_TRNST_UPG_FLG,'Y','是','否') AS SFGYQYJSGZSJDK --是否工业企业技术改造升级项目 MOD BY 20251230
    FROM S_LOAN T1
    LEFT JOIN ( SELECT DISTINCT M7.TAR_VALUE_CODE,M7.TAR_VALUE_NAME
                  FROM RRP_MDL.CODE_MAP M7 --码值表
                 WHERE M7.SRC_CLASS_CODE = 'P0003' --行业类别
                   AND M7.TAR_CLASS_CODE = 'T0025'
                   AND M7.MOD_FLG = 'MDM'
              ) M7 --高技术产业（制造业）
      ON T1.HIGH_TECH_IDY_MFG_CL = M7.TAR_VALUE_CODE
    LEFT JOIN (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY JYWYM ORDER BY JYWYM ) AS RN
                 FROM M_ADD_DG_003_MONEY T
                WHERE DATA_DATE = V_P_DATE 
               ) Z  --补录表-对公-账务基表
      ON Z.JYWYM = T1.RCPT_ID
     AND Z.RN = 1 -- 应急去重
     AND Z.DATA_DATE = V_P_DATE
    LEFT JOIN (SELECT CYML,M_CORE,M_NAME,CODE,NAME,SFDX
                 FROM M_DICT_G0107_REMAPPING_BL
                WHERE TYPE_CODE = 'G010701'
                GROUP BY CYML,M_CORE,M_NAME,CODE,NAME,SFDX
               ) F  --高技术产业
      ON TRIM(T1.LOAN_DIR_IDY) = F.CODE
/*    LEFT JOIN M_INDUSTRY_CLASSIFY I --战略新兴码值表
      ON TRIM(Z.TXZLXXXCYXL) = TRIM(I.INDUS_CATE_NAME)
     AND I.CLASSIFY = '战略新兴'*/
   WHERE T1.DATA_DT = V_P_DATE
     AND T1.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现')
     AND (NVL(T1.LOAN_NET_VAL,0) <> 0 --有余额
          OR ( NVL(T1.LOAN_NET_VAL,0) = 0 AND SUBSTR(T1.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4) ) --当年放款
         )
  )
   SELECT T1.DATA_DT                                 AS BGRQ                      --001 报告日期
         ,T1.RCPT_ID                                 AS JYWYM                     --002 交易唯一码
         ,T1.CONT_ID                                 AS ZHWYM                     --003 账户唯一码
         ,TRIM(T9.COUNTY_CD)                         AS JBJGSZXZQHDM              --004 经办机构所在行政区划代码
         ,T9.ORG_NAME                                AS JBJGMC                    --005 经办机构名称
         ,COALESCE(TRIM(T3.COUNTY_CD),TRIM(T3.CITY_CD),TRIM(T3.PROV_CD))
                                                     AS ZWJGSZXZQHDM              --006 账务机构机构所在行政区划代码
         ,T1.ORG_ID                                  AS ZWJGBH                    --007 账务机构编号
         ,T3.ORG_NAME                                AS ZWJGMC                    --008 账务机构名称
         ,'表内'                                     AS BNW                       --009 表内外
         ,T1.LOAN_BIZ_TYP                            AS TJYWPZ                    --010 统计业务品种
         ,CASE WHEN T1.LOAN_BIZ_TYP = '03020101' THEN '银行承兑汇票转贴现'
               WHEN T1.LOAN_BIZ_TYP = '03020102' THEN '商业承兑汇票转贴现'
               ELSE M1.SRC_VALUE_NAME         -- MOD LIUYU 应业务要求统计业务品种名称保持和旧系统一致
          END                                        AS TJYWPZMC                  --011 统计业务品种名称
         ,T1.STD_PROD_ID                             AS DKYWPZ                    --012 贷款业务品种
         ,T8.PROD_NAME                               AS DKYWPZMC                  --013 贷款业务品种名称
         ,'不适用'                                   AS BWYWLB                    --014 表外业务类别
         ,'各项贷款'                                 AS SXYWLB                    --015 授信业务类别
         ,T1.SUBJ_ID                                 AS KJKMDM                    --016 会计科目代码
         ,T5.SUBJ_NM                                 AS KJKMMC                    --017 会计科目名称
         ,T1.CUST_ID                                 AS KHWYM                     --018 客户唯一码
         ,CASE WHEN T1.CUST_LRG_CL = '01' THEN '个人客户'
               WHEN T1.CUST_LRG_CL = '02' AND T4.TYBZ = 'Y' THEN '同业客户'
               WHEN T1.CUST_LRG_CL = '02' AND T4.TYBZ <> 'Y' THEN '对公客户'
               ELSE '不适用'
          END                                        AS TJKHLB                    --019 统计客户类别
         ,T4.CUST_NM                                 AS KHMC                      --020 客户名称
         ,T1.LVL5_CL                                 AS WJFL                      --021 五级分类
         ,CASE WHEN T1.LVL5_CL = '01' THEN '正常类'
               WHEN T1.LVL5_CL = '02' THEN '关注类'
               WHEN T1.LVL5_CL = '03' THEN '次级类'
               WHEN T1.LVL5_CL = '04' THEN '可疑类'
               WHEN T1.LVL5_CL = '05' THEN '损失类'
          END                                        AS WJFLMC                    --022 五级分类名称
         ,CASE WHEN T1.LVL5_CL IN ('03','04','05') 
               THEN '是'
               ELSE '否'
          END                                        AS SFBL                      --023 是否不良
         ,T1.LOAN_NET_VAL * U.EXRT                   AS TJYE                      --024 统计余额（元）
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 2) NOT IN ('03','04','05','07','90')
                AND SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) NOT IN ('0204','0205','0206')
                AND TRIM(T1.LOAN_BIZ_TYP) IS NOT NULL
               THEN '普通贷款'
               WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0301' THEN '贴现'
               WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0302' THEN '买断式转贴现'
               WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0204','0399') THEN '贸易融资'
               WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0206' THEN '融资租赁'
               WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0205' THEN '各项垫款'
               WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 2) IN ('04','07') --从非金融机构买入返售资产/信用卡
               THEN '其他贷款'
               ELSE '不适用'
          END                                        AS DAIKLB                    --025 贷款类别
         ,CASE WHEN T1.STD_PROD_ID IN ('203040100001','203040400001') THEN '承兑汇票'
               WHEN T1.STD_PROD_ID IN ('203040500001','203040500002') THEN '融资性保函'
               WHEN T1.STD_PROD_ID IN ('203040600001') THEN '其他等同于贷款的授信业务'
               WHEN T1.STD_PROD_ID IN ('203040200001') THEN '跟单信用证'
               WHEN T1.STD_PROD_ID IN ('203040700001') THEN '其他与贸易相关的或有项目'
               ELSE '不适用'
          END                                        AS DIANKLB                   --026 垫款类别
         ,T1.CUR                                     AS BZ                        --027 币种
         ,DECODE(T1.CUR,'CNY','人民币','外币')       AS BZLB                      --028 币种类别
         ,T1.LOAN_ACT_DSTR_DT                        AS YSQSRQ                    --029 原始起始日期
         ,T1.LOAN_ORIG_EXP_DT                        AS YSDQRQ                    --030 原始到期日期
         ,''                                         AS YSQXQJ                    --031 原始期限区间
         ,CASE WHEN T1.ORIG_TERM_CODE = '3M' THEN '三个月以内'
               WHEN T1.ORIG_TERM_CODE = '6M' THEN '三个月至六个月'
               WHEN T1.ORIG_TERM_CODE = '12M' THEN '六个月至一年'
               WHEN T1.ORIG_TERM_CODE = '2Y' THEN '一年至两年'
               WHEN T1.ORIG_TERM_CODE = '3Y' THEN '两年至三年'
               WHEN T1.ORIG_TERM_CODE = '5Y' THEN '三年至五年'
               WHEN T1.ORIG_TERM_CODE = '5YA' THEN '五年以上'
               ELSE '不适用'
          END                                        AS YSQXQJMC                  --032 原始期限区间名称
         ,REPLACE(T2.PRIN_OVD_DT,'20991231','')      AS BJZZYQRQ                  --033 本金最早逾期日期
         ,CASE WHEN NVL(T1.OVD_DAYS,0) > 0
               THEN TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - T1.OVD_DAYS,'YYYYMMDD')
          END                                        AS ZZYQRQ                    --034 最早逾期日期
         ,T1.OVD_DAYS                                AS TJYQTS                    --035 统计逾期天数（天）
         ,''                                         AS YQTSQJ                    --036 逾期天数区间
         ,CASE WHEN NVL(T1.OVD_DAYS,0) < = 0 THEN '未逾期'
               WHEN T1.OVD_DAYS > 0   AND T1.OVD_DAYS < = 30  THEN '逾期30天以内'
               WHEN T1.OVD_DAYS > 30  AND T1.OVD_DAYS < = 60  THEN '逾期31天到60天'
               WHEN T1.OVD_DAYS > 60  AND T1.OVD_DAYS < = 90  THEN '逾期61天到90天'
               WHEN T1.OVD_DAYS > 90  AND T1.OVD_DAYS < = 180 THEN '逾期91天到180天'
               WHEN T1.OVD_DAYS > 180 AND T1.OVD_DAYS < = 270 THEN '逾期181天到270天'
               WHEN T1.OVD_DAYS > 270 AND T1.OVD_DAYS < = 360 THEN '逾期271天到360天'
               WHEN T1.OVD_DAYS > 360 THEN '逾期361天以上'
          END                                        AS YQTSQJMC                  --037 逾期天数区间名称
         ,CASE WHEN T1.LOAN_BIZ_TYP = '0399' THEN '买断式其他票据类资产'
               WHEN T1.LOAN_BIZ_TYP LIKE '0302%' THEN '买断式转贴现'
               ELSE '对公贷款'
          END                                        AS DKPZ                      --038 贷款品种
         ,TMP.SFTXGJSCY                              AS SFTXGJSCY                 --039 是否投向高技术产业
         ,TMP.TXGJSCYMLMC                            AS TXGJSCYMLMC               --041 投向高技术产业门类名称
         ,T2.RENEW_EXP_DAY                           AS ZQDQRQ                    --042 展期到期日期
         ,CASE WHEN T1.EXTN_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFZQ                      --043 是否展期
         ,CASE WHEN T1.LOAN_BIZ_TYP = '0203' THEN '是'
               ELSE '否'
          END                                        AS SFBGDK                    --044 是否并购贷款
         ,CASE WHEN T1.OV_SEA_MRG_LOAN_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFJWBGDK                  --045 是否境外并购贷款
         ,T1.LOAN_AMT * U.EXRT                       AS FKJE                      --046 放款金额（元）
         ,T2.EXEC_RATE                               AS ZXLL                      --047 执行利率（年）
         ,T1.INCOME_ANNUAL * U.EXRT                  AS NHLXSY                    --048 年化利息收益（元）
         ,CASE WHEN T1.DATA_SRC = '票据转贴现' THEN '不适用'
               ELSE NVL(M2.SRC_VALUE_NAME,'不适用')
          END                                        AS SSGMJJHYMLMC              --049 所属国民经济行业门类名称
         ,CASE WHEN T1.DATA_SRC = '票据转贴现' THEN '不适用'
               WHEN T1.LOAN_DIR_BIO_FLG = 'N' THEN '境外贷款'
               ELSE NVL(M3.SRC_VALUE_NAME,'不适用')
          END                                        AS TXGMJJXYMLMC              --050 投向国民经济行业门类名称
         ,CASE WHEN T1.DATA_SRC = '票据转贴现' THEN '不适用'
               WHEN T1.LOAN_DIR_BIO_FLG = 'N' THEN '境外贷款'
               ELSE NVL(M4.SRC_VALUE_NAME,'不适用')
          END                                        AS TXGMJJXYDLMC              --051 投向国民经济行业大类名称
         ,CASE WHEN T1.DATA_SRC = '票据转贴现' THEN '不适用'
               WHEN T1.LOAN_DIR_BIO_FLG = 'N' THEN '境外贷款'
               ELSE NVL(M5.SRC_VALUE_NAME,'不适用')
          END                                        AS TXGMJJXYZLMC              --052 投向国民经济行业中类名称
         ,CASE WHEN T1.DATA_SRC = '票据转贴现' THEN '不适用'
               WHEN T1.LOAN_DIR_BIO_FLG = 'N' THEN '境外贷款'
               ELSE NVL(M6.SRC_VALUE_NAME,'不适用')
          END                                        AS TXGMJJXYXLMC              --053 投向国民经济行业小类名称
         ,T1.LOAN_DIR_IDY                            AS TXGMJJXYXLDM              --054 投向国民经济行业小类代码
         ,TMP.SFGYQYJSGZSJDK                         AS SFGYQYJSGZSJDK            --057 是否工业企业技术改造升级贷款
         ,TMP.ZLXXXCYLBMC                            AS ZLXXXCYLBMC               --059 战略性新兴产业类别名称
         ,CASE WHEN T1.LOAN_DIR_BIO_FLG = 'N' THEN '是' -- Y 境内 N 境外
               ELSE '否'
          END                                        AS TXSFJW                    --061 投向是否境外
         ,TMP.SFTXWHCYDL                             AS SFTXWHCYDL                --065 是否投向文化产业大类
         ,CASE WHEN T1.ENT_SCALE = 'L' THEN '大型企业'
               WHEN T1.ENT_SCALE = 'M' THEN '中型企业'
               WHEN T1.ENT_SCALE = 'S' THEN '小型企业'
               WHEN T1.ENT_SCALE = 'X' THEN '微型企业'
               ELSE '其他法人客户'
          END                                        AS TJXWQYLBMC                --077 统计小微企业类别名称
         ,REPLACE(M8.TAR_VALUE_NAME,'企业','')       AS QYCZRJJCFZLMC             --078 企业出资人经济成分中类名称
         ,T1.SGL_CRDT_AMT                            AS SXZED                     --079 授信总额度（元） --已折算为人民币
         ,CASE WHEN T1.IS_CBRC_ENT = 'Y' 
                AND T1.ENT_SCALE IN ('S','X') 
                AND T1.SGL_CRDT_AMT <= 10000000
               THEN '是'
               ELSE '否'
          END                                        AS SFPHXWQY                  --080 是否普惠小微企业
         ,''                                         AS TJDBFS                    --081 统计担保方式
         ,DECODE(T1.TJDBFS,'DZY','抵质押'
                          ,'BZ','保证'
                          ,'XY','信用'
                          ,'不适用')                 AS TJDBFSMC                  --082 统计担保方式名称
         ,CASE WHEN T7.SUB_GUA_MODE = '1' THEN '信用'
               WHEN T7.SUB_GUA_MODE = '2' THEN '保证'
               WHEN T7.SUB_GUA_MODE = '3' THEN '抵押'
               WHEN T7.SUB_GUA_MODE = '4' THEN '质押'
               WHEN T7.SUB_GUA_MODE = '5' THEN '保证+抵押'
               WHEN T7.SUB_GUA_MODE = '6' THEN '保证+质押'
               WHEN T7.SUB_GUA_MODE = '7' THEN '抵押+质押'
               WHEN T7.SUB_GUA_MODE = '8' THEN '保证+抵押+质押'
               WHEN T7.SUB_GUA_MODE = '9' THEN '无担保'
          END                                        AS DBFSNBKJ                  --083 担保方式内部口径
         ,T1.GUA_MODE                                AS ZDBFSDM                   --084 主担保方式代码
         ,DECODE(T1.GUA_MODE,'1','抵押'
                            ,'2','质押'
                            ,'3','保证'
                            ,'4','信用'
                            ,'不适用')               AS ZDBFS                     --085 主担保方式
         ,CASE WHEN T1.REV_GUAR_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFFDB                     --086 是否反担保
         ,CASE WHEN T1.REL_PSN_GUA_LOAN_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFGXRBZ                   --087 是否关系人保证
         ,CASE WHEN T2.LOAN_PROD_NM LIKE '%法人透支%' THEN '是'
               ELSE '否'
          END                                        AS SFFRZHTZ                  --088 是否法人账户透支
         ,CASE WHEN T1.NON_REPY_PRIN_RENEW_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFWHBXD                   --089 是否无还本续贷
         ,/*CASE WHEN T1.STD_PROD_ID IN ('203010100002','203010500001') --产品编号为随兴贷、法人透支
               OR T1.RCPT_ID LIKE 'XB%'
               OR T1.RCPT_ID LIKE 'KSW%'
               THEN '是'
               ELSE '否'
          END*/
         CASE WHEN T1.REV_LOAN_FLG = 'Y' THEN '是'
              ELSE '否' END                          AS SFXHD                     --090 是否循环贷
         ,''                                         AS HPCDFLB                   --091 汇票承兑方类别
         ,CASE WHEN T1.STD_PROD_ID IN ('204010100001','204010200001') THEN '银行承兑'
               WHEN T1.STD_PROD_ID IN ('204010100002','204010200002') THEN '商业承兑'
               ELSE '不适用'
          END                                        AS HPCDFLBMC                 --092 汇票承兑方类别名称
         ,CASE WHEN T1.BANK_TAX_COOP_LOAN_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFYSHZ                    --093 是否银税合作
         ,/*CASE WHEN T1.PRCN_CUST_FLG = 'Y' AND T1.CORP_CUST_TYP LIKE 'A%' AND T1.ENT_SCALE IN ('M','S') THEN '是'
               ELSE '否'
          END    */
          CASE WHEN T1.PRCN_CUST_FLG = 'Y' THEN '是'
                ELSE '否'
          END                                        AS SFZJTXZXQY                --094 是否专精特新中小企业    -- MODIFY BY YJY IN 20240220
         ,CASE WHEN T1.ENT_CLOSE_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFGTQY                    --095 是否关停企业
         ,'不适用'                                   AS BZXAJGCLB                 --096 保障性安居工程类别
         ,REPLACE(REPLACE(T2.FIR_LON_DT,'20991231',''),'00010101','')
                                                     AS SDRQ                      --097 首贷日期
         ,CASE WHEN SUBSTR(T2.FIR_LON_DT,1,4) = SUBSTR(V_P_DATE,1,4) 
                AND T2.FIR_LON_DT = T2.LOAN_ACT_DSTR_DT 
               THEN '是'
               ELSE '否'
           END                                       AS SFZXSBDK                  --098 是否征信首笔贷款
         ,T1.RCPT_STAT                               AS JJDKZT                    --099 借据贷款状态
         ,CASE WHEN T1.EXTN_FLG = 'Y' THEN '展期'
               WHEN T1.RCPT_STAT IN ('A','D004','D') THEN '正常'
               WHEN T1.RCPT_STAT = 'B' THEN '逾期'
               ELSE '正常'
          END                                        AS CLDKZT                    --100 存量贷款状态
         ,DECODE(T2.LOAN_FINC_SPT_MODE,'0202','贴息'
                                      ,'无财政支持') AS DKCZFCFS                  --101 贷款财政扶持方式
         ,DECODE(T1.LEAD_AGRI_FLG,'Y','是','否')     AS SFNYCYHLTQY               --102 是否农业产业化龙头企业
         ,DECODE(T1.DELINE_FLG,'Y','是','否')        AS SFYQ                      --103 是否延期
         ,DECODE(T1.FIN_SUB_COR_FLG,'Y','是','否')   AS SFWLCZGSCP                --104 是否为理财子公司产品
         ,T2.LOAN_USEAGE                             AS DKYT                      --109 贷款用途
         ,T1.LOAN_AMT * U.EXRT / 10000               AS JJFKJEZW                  --110 借据放款金额折人民币（万元）
         ,T1.LOAN_NET_VAL * U.EXRT / 10000           AS JJYEZW                    --111 借据余额折人民币净值（万元）
         ,NVL(T11.IN_BS_OVER_INT_BAL,0) + NVL(T11.OFF_BS_OVER_INT_BAL,0)
                                                     AS QX                        --112 欠息
         ,NVL(TRIM(T11.PRIC_PNLT),0)                 AS FAX                       --113 罚息
         ,NVL(TRIM(T11.INT_PNLT),0)                  AS FUX                       --114 复息
         ,T7.CONT_AMT                                AS HTYE                      --115 合同余额（原币种）
         ,CASE WHEN T1.RCMB_LOAN_FLG = 'Y' THEN '0209'
          ELSE T7.LOAN_HAPP_TYPE_CD END              AS FSLXDM                    --116 发生类型代码
         ,CASE WHEN T1.RCMB_LOAN_FLG = 'Y' THEN '重组贷款' 
               WHEN T7.LOAN_HAPP_TYPE_CD = '0100' THEN '新增'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0101' THEN '授信条件变更'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0102' THEN '原额度续作'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0103' THEN '增额续作'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0104' THEN '减额续作'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0201' THEN '展期'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0202' THEN '借新还旧'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0204' THEN '债务重组'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0205' THEN '新借'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0206' THEN '复议'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0207' THEN '年审'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0208' THEN '变更借款人'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0209' THEN '重组贷款'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0210' THEN '无还本续贷'
          END                                        AS FSLX                      --117 发生类型
         ,T12.RELA_CONT_ID                           AS YHTBH                     --118 原合同编号
         ,CASE WHEN T1.RCMB_LOAN_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFCZ                      --119 是否重组
         ,CASE WHEN T1.RCMB_LOAN_FLG = 'Y' THEN T1.LOAN_ACT_DSTR_DT
               ELSE ''
          END                                        AS CZRQ                      --120 重组日期
         ,''                                         AS YSQXLB                    --121 原始期限类别
         ,CASE WHEN T1.LOAN_TERM IN ('S') THEN '短期'
               WHEN T1.LOAN_TERM IN ('M','L') THEN '中长期'
               ELSE '不适用'
          END                                        AS YSQXLBMC                  --122 原始期限类别名称
         ,''                                         AS QYCZRJJCFZL               --123 企业出资人经济成分中类
         ,CASE WHEN NVL(T1.OVD_DAYS,0) <=0 THEN 0
               ELSE T1.LOAN_NET_VAL * U.EXRT
          END                                        AS TJYQBJJE                  --124 统计逾期本金金额（元）
         ,TMP.TXGJSZZYDLMC                           AS TXGJSZZYDLMC              --126 投向高技术制造业大类名称
         ,TMP.TXSZJJHXCYDLMC                         AS TXSZJJHXCYDLMC            --128 投向数字经济核心产业大类名称
         ,T1.DATA_SRC                                AS DEPARTMENTD               --129 归属部门
         ,TMP.SFTXZSCQMJXCY                          AS SFTXZSCQMJXCY             --132 是否投向知识产权密集型产业
         ,T13.BILL_NUM                               AS PJBH                      --133 票据编号
         ,T4.CUST_MGR_ID                             AS KHZBKHJLH                 --134 客户主办客户经理号
         ,T4.CUST_TELLER_ID                          AS KHZBGYH                   --135 客户主办柜员号
         ,T4.CUST_MGR_NAME                           AS KHZBKHJLMC                --136 客户主办客户经理名称
         ,T4.CUST_MGR_BELONG_ORG_ID                  AS KHZBKHJLSSJG              --137 客户主办客户经理所属机构
         ,T2.LOAN_MGR_ID                             AS JJZBKHJLH                 --138 借据主办客户经理号
         ,T2.LOAN_TELLER_ID                          AS JJZBGYH                   --139 借据主办柜员号
         ,T2.LOAN_MGR_NAME                           AS JJZBKHJLMC                --140 借据主办客户经理名称
         ,T2.LOAN_MGR_BELONG_ORG_ID                  AS JJZBKHJLSSJG              --141 借据主办客户经理所属机构
         ,T1.OVD_PRIN_BAL * U.EXRT                   AS YQBJJE                    --142 逾期本金金额(元)
         ,T2.OPER_ORG_ID                             AS JBJGBH                    --143 经办机构编号
         ,U.EXRT                                     AS DRMBZSL                   --144 对人民币折算率
         ,T1.LOAN_NET_VAL                            AS JJYE_YBZ                  --145 借据余额（原币值）
         ,T1.LOAN_AMT                                AS FKJE_YBZ                  --146 放款金额（原币值）
         ,CASE WHEN T1.DATA_SRC IN ('票据转贴现') THEN '不适用'
               ELSE NVL(M11.SRC_VALUE_NAME,'不适用')
          END                                        AS SSGMJJHYDLMC              --147 所属国民经济行业大类名称
         ,CASE WHEN T1.DATA_SRC IN ('票据转贴现') THEN '不适用'
               ELSE NVL(M12.SRC_VALUE_NAME,'不适用')
          END                                        AS SSGMJJHYZLMC              --148 所属国民经济行业中类名称
         ,CASE WHEN T1.DATA_SRC IN ('票据转贴现') THEN '不适用'
               ELSE NVL(M13.SRC_VALUE_NAME,'不适用')
          END                                        AS SSGMJJHYXLMC              --149 所属国民经济行业小类名称
         ,M14.TAR_VALUE_NAME                         AS QYCZRJJCFXLMC             --150 企业出资人经济成分小类名称
         ,T10.DUBIL_ID_TX                            AS ZTJJH                     --155 转贴现对应直贴借据号
         ,T1.SFJGMDZDZJTXZXQY                        AS SFJGMDZDZJTXZXQY          --156 是否监管名单中的专精特新中小企业
         ,T1.SFYLCY                                  AS SFYLCY                    --157 是否养老产业
         ,T1.SFTXZFHSHZBHZ_PPP_XM                    AS SFTXZFHSHZBHZ_PPP_XM      --158 是否投向政府和社会资本合作（PPP）项目
         ,T1.SFXJZFFDK                               AS SFXJZFFDK                 --159 是否新机制发放贷款
         ,CASE WHEN T1.BGDKLX = '10' THEN '控制型并购贷款'
               WHEN T1.BGDKLX = '20' THEN '参股型并购贷款'
          END                                        AS BGDKLX                    --160 并购贷款类型
         ,CASE WHEN T1.SFTYJRCBQY = 'Y' THEN '是'
               ELSE '否' END                         AS SFTYJRCBQY                --161 是否退役军人创办企业
         ,CASE WHEN T1.FKSQYGM = 'L' THEN '大型企业'
               WHEN T1.FKSQYGM = 'M' THEN '中型企业'
               WHEN T1.FKSQYGM = 'S' THEN '小型企业'
               WHEN T1.FKSQYGM = 'X' THEN '微型企业'
               ELSE '其他法人客户'
          END                                        AS FKSQYGM                   --162 放款时企业规模
         ,REPLACE(M9.TAR_VALUE_NAME,'企业','')       AS FKSKGLX                   --163 放款时控股类型    
         ,CASE WHEN T1.FKYQYGM = 'L' THEN '大型企业'
               WHEN T1.FKYQYGM = 'M' THEN '中型企业'
               WHEN T1.FKYQYGM = 'S' THEN '小型企业'
               WHEN T1.FKYQYGM = 'X' THEN '微型企业'
               ELSE '其他法人客户'
          END                                        AS FKYQYGM                   --164 放款月企业规模
         ,REPLACE(M10.TAR_VALUE_NAME,'企业','')      AS FKYKGLX                   --165 放款月控股类型      
    FROM RRP_MDL.S_LOAN T1 --贷款业务整合表
    LEFT JOIN LOAN_DIR_IDY_TMP TMP --五大产业临时表
      ON T1.RCPT_ID = TMP.RCPT_ID
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO T2 --表内借据信息
      ON T2.RCPT_ID = T1.RCPT_ID
     AND T2.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T3 --机构表
      ON T3.ORG_ID = T1.ORG_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T4 --对公客户信息
      ON T4.CUST_ID = T1.CUST_ID
     AND T4.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_GL_INFO T5 --总账会计科目信息表
      ON T5.SUBJ_ID = T1.SUBJ_ID
     AND T5.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO T7 --贷款合同信息
      ON T7.CONT_ID = T1.CONT_ID
     AND T7.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T8 --标准产品信息表
      ON T8.PROD_ID = T1.STD_PROD_ID
     AND T8.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T9 --机构表
      ON T9.ORG_ID = T2.OPER_ORG_ID
     AND T9.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT C.DUBIL_ID AS DUBIL_ID_ZT
                      ,A.BILL_NUM AS BILL_NUM
                      ,D.DUBIL_ID AS DUBIL_ID_TX
                 FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --转贴现
                INNER JOIN RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO B --贴现
                   ON A.BILL_NUM = B.BILL_NUM
                  AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO C --对公贷款借据信息 取转贴借据号
                   ON C.BILL_ID = A.BILL_ID
                  AND C.STD_PROD_ID IN ('204010100001', '204010100002')
                  AND C.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                 LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO D --对公贷款借据信息 取贴现借据号
                   ON D.BILL_UNIQ_MARK_ID = B.BILL_ENTRY_ID
                  AND D.STD_PROD_ID IN ('204010200001', '204010200002')
                  AND D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                  AND TRIM(D.DUBIL_ID) IS NOT NULL -- 数据会重复，去重
                GROUP BY C.DUBIL_ID,A.BILL_NUM,D.DUBIL_ID
              ) T10
      ON T10.DUBIL_ID_ZT = T1.RCPT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T11 -- 对公借据表
      ON T11.DUBIL_ID = T1.RCPT_ID
     AND T11.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T12 -- 对公合同表
      ON T12.CONT_ID = T1.CONT_ID
     AND T12.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT BILL_NO,BILL_NUM
                 FROM RRP_MDL.M_BILL_INFO
                WHERE DATA_DT = V_P_DATE
                GROUP BY BILL_NO,BILL_NUM)  T13 -- 票据信息表
      ON T13.BILL_NO = T2.BILL_NO
    LEFT JOIN (SELECT DISTINCT CYML,M_CORE,M_NAME,CODE,NAME,SFDX
               FROM RRP_MDL.M_DICT_G0107_REMAPPING_BL
               WHERE TYPE_CODE = 'G010701'
              ) G  --高技术产业
      ON G.CODE = T1.LOAN_DIR_IDY
    LEFT JOIN RRP_MDL.O_IOL_ICMS_PUTOUT_ONLINE T14 --线上放款申请记录
      ON T1.RCPT_ID = T14.DUEBILLSERIALNO
     AND T14.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T14.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U --汇率表
      ON U.DATA_DT = V_P_DATE
     AND U.BASE_CUR = T1.CUR
     AND U.CNV_CUR = 'CNY'
    LEFT JOIN RRP_MDL.CODE_MAP M1 --码值表
      ON M1.TAR_CLASS_CODE = 'T0001' --贷款类型
     AND M1.SRC_CLASS_CODE = 'T0001'
     AND M1.MOD_FLG = 'IMAS'
     AND M1.SRC_VALUE_CODE = T1.LOAN_BIZ_TYP
    LEFT JOIN RRP_MDL.CODE_MAP M2 --码值表
      ON M2.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M2.SRC_CLASS_CODE = 'P0003'
     AND M2.MOD_FLG = 'MDM'
     AND M2.SRC_VALUE_CODE = SUBSTR(TRIM(T1.CUST_BLNG_IDY),1,1) --所属行业 门类
    LEFT JOIN RRP_MDL.CODE_MAP M3 --码值表
      ON M3.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M3.SRC_CLASS_CODE = 'P0003'
     AND M3.MOD_FLG = 'MDM'
     AND M3.SRC_VALUE_CODE = SUBSTR(TRIM(T1.LOAN_DIR_IDY),1,1) --投向行业 门类
    LEFT JOIN RRP_MDL.CODE_MAP M4 --码值表
      ON M4.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M4.SRC_CLASS_CODE = 'P0003'
     AND M4.MOD_FLG = 'MDM'
     AND M4.SRC_VALUE_CODE = SUBSTR(TRIM(T1.LOAN_DIR_IDY),1,3) --投向行业 大类
    LEFT JOIN RRP_MDL.CODE_MAP M5 --码值表
      ON M5.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M5.SRC_CLASS_CODE = 'P0003'
     AND M5.MOD_FLG = 'MDM'
     AND M5.SRC_VALUE_CODE = SUBSTR(TRIM(T1.LOAN_DIR_IDY),1,4) --投向行业 中类
    LEFT JOIN RRP_MDL.CODE_MAP M6 --码值表
      ON M6.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M6.SRC_CLASS_CODE = 'P0003'
     AND M6.MOD_FLG = 'MDM'
     AND M6.SRC_VALUE_CODE = TRIM(T1.LOAN_DIR_IDY)             --投向行业 小类
    LEFT JOIN RRP_MDL.CODE_MAP M7 --码值表
      ON M7.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M7.TAR_CLASS_CODE = 'T0025'
     AND M7.MOD_FLG = 'MDM'
     AND M7.SRC_VALUE_CODE = TRIM(T1.LOAN_DIR_IDY)     --高技术产业（制造业）
    LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME
                 FROM RRP_MDL.CODE_MAP  --码值表
                WHERE TAR_CLASS_CODE = 'C0004' --经济成分代码
                  AND SRC_CLASS_CODE = 'CD1417'
                  AND MOD_FLG = 'MDM' ) M8
      ON M8.TAR_VALUE_CODE = SUBSTR(TRIM(T1.ENT_HLDG_TYP),1,1)     --企业控股类型 中类     
    LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME
                 FROM RRP_MDL.CODE_MAP  --码值表
                WHERE TAR_CLASS_CODE = 'C0004' --经济成分代码
                  AND SRC_CLASS_CODE = 'CD1417'
                  AND MOD_FLG = 'MDM' ) M9
      ON M9.TAR_VALUE_CODE = SUBSTR(TRIM(T1.FKSKGLX),1,1)           --企业控股类型 中类        
    LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME
                 FROM RRP_MDL.CODE_MAP  --码值表
                WHERE TAR_CLASS_CODE = 'C0004' --经济成分代码
                  AND SRC_CLASS_CODE = 'CD1417'
                  AND MOD_FLG = 'MDM' ) M10
      ON M10.TAR_VALUE_CODE = SUBSTR(TRIM(T1.FKYKGLX),1,1)           --企业控股类型 中类         
    LEFT JOIN RRP_MDL.CODE_MAP M11 --码值表
      ON M11.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M11.SRC_CLASS_CODE = 'P0003'
     AND M11.MOD_FLG = 'MDM'
     AND M11.SRC_VALUE_CODE = SUBSTR(TRIM(T1.CUST_BLNG_IDY),1,3) --所属行业 大类
    LEFT JOIN RRP_MDL.CODE_MAP M12 --码值表
      ON M12.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M12.SRC_CLASS_CODE = 'P0003'
     AND M12.MOD_FLG = 'MDM'
     AND M12.SRC_VALUE_CODE = SUBSTR(TRIM(T1.CUST_BLNG_IDY),1,4) --所属行业 中类
    LEFT JOIN RRP_MDL.CODE_MAP M13 --码值表
      ON M13.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M13.SRC_CLASS_CODE = 'P0003'
     AND M13.MOD_FLG = 'MDM'
     AND M13.SRC_VALUE_CODE = TRIM(T1.CUST_BLNG_IDY) --所属行业 小类
    LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME
                 FROM RRP_MDL.CODE_MAP  --码值表
                WHERE TAR_CLASS_CODE = 'C0004' --经济成分代码
                  AND SRC_CLASS_CODE = 'CD1417'
                  AND MOD_FLG = 'MDM' ) M14
      ON M14.TAR_VALUE_CODE = TRIM(T1.ENT_HLDG_TYP)     --企业控股类型 小类
   WHERE T1.DATA_DT = V_P_DATE
     AND T1.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现')
     AND (NVL(T1.LOAN_NET_VAL,0) <> 0 --有余额
          OR ( NVL(T1.LOAN_NET_VAL,0) = 0 AND SUBSTR(T1.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4) ) --当年放款
         )
     AND NVL(T4.CUST_CL,'A') <> 'E' --剔除个体工商户
   ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '表外数据_插入主表';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND*/ INTO RRP_MDL.A_FGB_ACCT_LOAN NOLOGGING
    (
          BGRQ                      --001 报告日期
         ,JYWYM                     --002 交易唯一码
         ,ZHWYM                     --003 账户唯一码
         ,JBJGSZXZQHDM              --004 经办机构机构所在行政区划代码
         ,JBJGMC                    --005 经办机构名称
         ,ZWJGSZXZQHDM              --006 账务机构机构所在行政区划代码
         ,ZWJGBH                    --007 账务机构编号
         ,ZWJGMC                    --008 账务机构名称
         ,BNW                       --009 表内外
         ,TJYWPZ                    --010 统计业务品种
         ,TJYWPZMC                  --011 统计业务品种名称
         ,DKYWPZ                    --012 贷款业务品种
         ,DKYWPZMC                  --013 贷款业务品种名称
         ,BWYWLB                    --014 表外业务类别
         ,SXYWLB                    --015 授信业务类别
         ,KJKMDM                    --016 会计科目代码
         ,KJKMMC                    --017 会计科目名称
         ,KHWYM                     --018 客户唯一码
         ,TJKHLB                    --019 统计客户类别
         ,KHMC                      --020 客户名称
         ,WJFL                      --021 五级分类
         ,WJFLMC                    --022 五级分类名称
         ,SFBL                      --023 是否不良
         ,TJYE                      --024 统计余额（元）
         ,DAIKLB                    --025 贷款类别
         ,DIANKLB                   --026 垫款类别
         ,BZ                        --027 币种
         ,BZLB                      --028 币种类别
         ,YSQSRQ                    --029 原始起始日期
         ,YSDQRQ                    --030 原始到期日期
         ,YSQXQJ                    --031 原始期限区间
         ,YSQXQJMC                  --032 原始期限区间名称
         ,BJZZYQRQ                  --033 本金最早逾期日期
         ,ZZYQRQ                    --034 最早逾期日期
         ,TJYQTS                    --035 统计逾期天数（天）
         ,YQTSQJ                    --036 逾期天数区间
         ,YQTSQJMC                  --037 逾期天数区间名称
         ,DKPZ                      --038 贷款品种
         ,SFTXGJSCY                 --039 是否投向高技术产业
         ,TXGJSCYMLMC               --041 投向高技术产业门类名称
         ,ZQDQRQ                    --042 展期到期日期
         ,SFZQ                      --043 是否展期
         ,SFBGDK                    --044 是否并购贷款
         ,SFJWBGDK                  --045 是否境外并购贷款
         ,FKJE                      --046 放款金额（元）
         ,ZXLL                      --047 执行利率（年）
         ,NHLXSY                    --048 年化利息收益（元）
         ,SSGMJJHYMLMC              --049 所属国民经济行业门类名称
         ,TXGMJJXYMLMC              --050 投向国民经济行业门类名称
         ,TXGMJJXYDLMC              --051 投向国民经济行业大类名称
         ,TXGMJJXYZLMC              --052 投向国民经济行业中类名称
         ,TXGMJJXYXLMC              --053 投向国民经济行业小类名称
         ,TXGMJJXYXLDM              --054 投向国民经济行业小类代码
         ,SFGYQYJSGZSJDK            --057 是否工业企业技术改造升级贷款
         ,ZLXXXCYLBMC               --059 战略性新兴产业类别名称
         ,TXSFJW                    --061 投向是否境外
         ,SFTXWHCYDL                --065 是否投向文化产业大类
         ,TJXWQYLBMC                --077 统计小微企业类别名称
         ,QYCZRJJCFZLMC             --078 企业出资人经济成分中类名称
         ,SXZED                     --079 授信总额度（元）
         ,SFPHXWQY                  --080 是否普惠小微企业
         ,TJDBFS                    --081 统计担保方式
         ,TJDBFSMC                  --082 统计担保方式名称
         ,DBFSNBKJ                  --083 担保方式内部口径
         ,ZDBFSDM                   --084 主担保方式代码
         ,ZDBFS                     --085 主担保方式
         ,SFFDB                     --086 是否反担保
         ,SFGXRBZ                   --087 是否关系人保证
         ,SFFRZHTZ                  --088 是否法人账户透支
         ,SFWHBXD                   --089 是否无还本续贷
         ,SFXHD                     --090 是否循环贷
         ,HPCDFLB                   --091 汇票承兑方类别
         ,HPCDFLBMC                 --092 汇票承兑方类别名称
         ,SFYSHZ                    --093 是否银税合作
         ,SFZJTXZXQY                --094 是否专精特新中小企业
         ,SFGTQY                    --095 是否关停企业
         ,BZXAJGCLB                 --096 保障性安居工程类别
         ,SDRQ                      --097 首贷日期
         ,SFZXSBDK                  --098 是否征信首笔贷款
         ,JJDKZT                    --099 借据贷款状态
         ,CLDKZT                    --100 存量贷款状态
         ,DKCZFCFS                  --101 贷款财政扶持方式
         ,SFNYCYHLTQY               --102 是否农业产业化龙头企业
         ,SFYQ                      --103 是否延期
         ,SFWLCZGSCP                --104 是否为理财子公司产品
         ,DKYT                      --109 贷款用途
         ,JJFKJEZW                  --110 借据放款金额折人民币（万元）
         ,JJYEZW                    --111 借据余额折人民币净值（万元）
         ,QX                        --112 欠息
         ,FAX                       --113 罚息
         ,FUX                       --114 复息
         ,HTYE                      --115 合同余额（原币种）
         ,FSLXDM                    --116 发生类型代码
         ,FSLX                      --117 发生类型
         ,YHTBH                     --118 原合同编号
         ,SFCZ                      --119 是否重组
         ,CZRQ                      --120 重组日期
         ,YSQXLB                    --121 原始期限类别
         ,YSQXLBMC                  --122 原始期限类别名称
         ,QYCZRJJCFZL               --123 企业出资人经济成分中类
         ,TJYQBJJE                  --124 统计逾期本金金额（元）
         ,TXGJSZZYDLMC              --126 投向高技术制造业大类名称
         ,TXSZJJHXCYDLMC            --128 投向数字经济核心产业大类名称
         ,DEPARTMENTD               --129 归属部门
         ,SFTXZSCQMJXCY             --132 是否投向知识产权密集型产业
         ,PJBH                      --133 票据编号
         ,KHZBKHJLH                 --134 客户主办客户经理号
         ,KHZBGYH                   --135 客户主办柜员号
         ,KHZBKHJLMC                --136 客户主办客户经理名称
         ,KHZBKHJLSSJG              --137 客户主办客户经理所属机构
         ,JJZBKHJLH                 --138 借据主办客户经理号
         ,JJZBGYH                   --139 借据主办柜员号
         ,JJZBKHJLMC                --140 借据主办客户经理名称
         ,JJZBKHJLSSJG              --141 借据主办客户经理所属机构
         ,YQBJJE                    --142 逾期本金金额(元)
         ,JBJGBH                    --143 经办机构编号
         ,DRMBZSL                   --144 对人民币折算率
         ,JJYE_YBZ                  --145 借据余额（原币值）
         ,FKJE_YBZ                  --146 放款金额（原币值）
         ,SSGMJJHYDLMC              --147 所属国民经济行业大类名称
         ,SSGMJJHYZLMC              --148 所属国民经济行业中类名称
         ,SSGMJJHYXLMC              --149 所属国民经济行业小类名称
         ,QYCZRJJCFXLMC             --150 企业出资人经济成分小类名称
    )
   SELECT T1.DATA_DT                                        AS BGRQ                      --001 报告日期
         ,T1.RCPT_ID                                        AS JYWYM                     --002 交易唯一码
         ,NVL(T2.LOAN_CONT_ID,T3.CONT_ID)                   AS ZHWYM                     --003 账户唯一码
         ,TRIM(T9.COUNTY_CD)                                AS JBJGSZXZQHDM              --004 经办机构所在行政区划代码
         ,T9.ORG_NAME                                       AS JBJGMC                    --005 经办机构名称
         ,COALESCE(TRIM(T4.COUNTY_CD),TRIM(T4.CITY_CD),TRIM(T4.PROV_CD))
                                                            AS ZWJGSZXZQHDM              --006 账务机构机构所在行政区划代码
         ,T1.ORG_ID                                         AS ZWJGBH                    --007 账务机构编号
         ,T4.ORG_NAME                                       AS ZWJGMC                    --008 账务机构名称
         ,'表外'                                            AS BNW                       --009 表内外
         ,T1.OUT_BIZ_VRTY                                   AS TJYWPZ                    --010 统计业务品种
         ,CASE WHEN T3.ACCT_TYP = '311' THEN '开出即期信用证'
               WHEN T3.ACCT_TYP = '312' THEN '开出远期信用证'
               WHEN T3.ACCT_TYP = '121' THEN '融资性保函'
               WHEN T3.ACCT_TYP = '211' THEN '非融资性保函'
               WHEN T2.ACCT_TYP = '111' THEN '银行承兑汇票'
               WHEN T2.ACCT_TYP = '112' THEN '商业承兑汇票'
               ELSE M1.SRC_VALUE_NAME         -- MOD LIUYU 应业务要求统计业务品种名称保持和旧系统一致
          END                                               AS TJYWPZMC                  --011 统计业务品种名称
         ,NVL(T2.STD_PROD_ID,T3.STD_PROD_ID)                AS DKYWPZ                    --012 贷款业务品种
         ,T10.PROD_NAME                                     AS DKYWPZMC                  --013 贷款业务品种名称
         ,CASE WHEN SUBSTR(T1.OUT_BIZ_VRTY,1,3) IN ('A01') THEN '承兑汇票'
               WHEN SUBSTR(T1.OUT_BIZ_VRTY,1,3) IN ('A02') 
                AND T1.ORIG_TERM_CODE IN ('3M','6M','12M')  THEN '一年以内的跟单信用证'
               WHEN SUBSTR(T1.OUT_BIZ_VRTY,1,3) IN ('A02') 
                AND T1.ORIG_TERM_CODE IN ('2Y','3Y','5Y','5YA')  THEN '一年以上的跟单信用证'
               WHEN T1.OUT_BIZ_VRTY IN ('A0301') THEN '融资性保函'
               WHEN T1.OUT_BIZ_VRTY IN ('A0302') THEN '非融资性保函'
               WHEN SUBSTR(T1.OUT_BIZ_VRTY,1,3) IN ('A04') THEN '信用风险仍在银行的销售与购买协议'
          END                                              AS BWYWLB                    --014 表外业务类别
         ,CASE WHEN T1.DATA_SRC = '银行承兑汇票' THEN '银行承兑汇票'
               ELSE '其他表外授信'
          END                                              AS SXYWLB                    --015 授信业务类别
         ,T1.SUBJ_ID                                       AS KJKMDM                    --016 会计科目代码
         ,T6.SUBJ_NM                                       AS KJKMMC                    --017 会计科目名称
         ,T1.CUST_ID                                       AS KHWYM                     --018 客户唯一码
         ,CASE WHEN T5.TYBZ = 'Y' THEN '同业客户'
               ELSE '对公客户'
          END                                              AS TJKHLB                    --019 统计客户类别
         ,T5.CUST_NM                                       AS KHMC                      --020 客户名称
         ,T11.LOAN_LEVEL5_CLS_CD                           AS WJFL                      --021 五级分类
         ,CASE WHEN T11.LOAN_LEVEL5_CLS_CD = '10' THEN '正常类'
               WHEN T11.LOAN_LEVEL5_CLS_CD = '20' THEN '关注类'
               WHEN T11.LOAN_LEVEL5_CLS_CD = '30' THEN '次级类'
               WHEN T11.LOAN_LEVEL5_CLS_CD = '40' THEN '可疑类'
               WHEN T11.LOAN_LEVEL5_CLS_CD = '50' THEN '损失类'
          END                                              AS WJFLMC                    --022 五级分类名称
         ,'否'                                             AS SFBL                      --023 是否不良
         ,T1.BAL * U.EXRT                                  AS TJYE                       --024 统计余额（元）
         --根据0703邮件反馈银承差异，银承部分第一数据源改为票据系统
         ,'不适用'                                         AS DAIKLB                    --025 贷款类别
         ,'不适用'                                         AS DIANKLB                   --026 垫款类别
         ,T1.CUR                                           AS BZ                        --027 币种
         ,DECODE(T1.CUR,'CNY','人民币','外币')             AS BZLB                      --028 币种类别
         ,T1.OCCUR_DT                                      AS YSQSRQ                    --029 原始起始日期
         ,NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT)               AS YSDQRQ                    --030 原始到期日期
         ,''                                               AS YSQXQJ                    --031 原始期限区间
         ,CASE WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>60 THEN '五年以上'
               WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>36 THEN '三年至五年'
               WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>24 THEN '两年至三年'
               WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>12 THEN '一年至两年'
               WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>6 THEN '六个月至一年'
               WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>3 THEN '三个月至六个月'
               WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>=0 THEN '三个月以内'
               ELSE '不适用'
          END                                              AS YSQXQJMC                  --032 原始期限区间名称
         ,''                                               AS BJZZYQRQ                  --033 本金最早逾期日期
         ,''                                               AS ZZYQRQ                    --034 最早逾期日期
         ,0                                                AS TJYQTS                    --035 统计逾期天数（天）
         ,''                                               AS YQTSQJ                    --036 逾期天数区间
         ,'未逾期'                                         AS YQTSQJMC                  --037 逾期天数区间名称
         ,'不适用'                                         AS DKPZ                      --038 贷款品种
         ,''                                               AS SFTXGJSCY                 --039 是否投向高技术产业
         /*DECODE(T1.HIGH_TECH_IDY_MFG_CL,'01','医药制造业'
                                        ,'02','航空、航天器及设备制造业'
                                        ,'03','电子及通信设备制造业'
                                        ,'04','计算机及办公设备制造业'
                                        ,'05','医疗仪器设备及仪器仪表制造业'
                                        ,'06','信息化学品制造业'
                                        ,'不适用')  */
         ,''                                               AS TXGJSCYMLMC               --041 投向高技术产业门类名称
         ,''                                               AS ZQDQRQ                    --042 展期到期日期
         ,'否'                                             AS SFZQ                      --043 是否展期
         ,'否'                                             AS SFBGDK                    --044 是否并购贷款
         ,'否'                                             AS SFJWBGDK                  --045 是否境外并购贷款
         ,T1.AMT * U.EXRT                                  AS FKJE                      --046 放款金额（元）
         ,''                                               AS ZXLL                      --047 执行利率（年）
         ,0                                                AS NHLXSY                    --048 年化利息收益（元）
         ,M2.SRC_VALUE_NAME                                AS SSGMJJHYMLMC              --049 所属国民经济行业门类名称
         ,NVL(M3.SRC_VALUE_NAME,'不适用')                  AS TXGMJJXYMLMC              --050 投向国民经济行业门类名称
         ,NVL(M4.SRC_VALUE_NAME,'不适用')                  AS TXGMJJXYDLMC              --051 投向国民经济行业大类名称
         ,NVL(M5.SRC_VALUE_NAME,'不适用')                  AS TXGMJJXYZLMC              --052 投向国民经济行业中类名称
         ,NVL(M6.SRC_VALUE_NAME,'不适用')                  AS TXGMJJXYXLMC              --053 投向国民经济行业小类名称
         ,T1.DIR_IDY                                       AS TXGMJJXYXLDM              --054 投向国民经济行业小类代码
         ,''                                               AS SFGYQYJSGZSJDK            --057 是否工业企业技术改造升级贷款
         ,''                                               AS ZLXXXCYLBMC               --059 战略性新兴产业类别名称
         ,'否'                                             AS TXSFJW                    --061 投向是否境外
         ,''                                               AS SFTXWHCYDL                --065 是否投向文化产业大类
         ,CASE WHEN T5.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）' )
               THEN  -- 当客户为企业的前提下，取统计小微企业类别
                    CASE WHEN T5.ENT_SCALE = 'L' THEN '大型企业'
                         WHEN T5.ENT_SCALE = 'M' THEN '中型企业'
                         WHEN T5.ENT_SCALE = 'S' THEN '小型企业'
                         WHEN T5.ENT_SCALE = 'X' THEN '微型企业'
                         ELSE '其他法人客户' END
               ELSE '其他法人客户'
          END                                              AS TJXWQYLBMC                --077 统计小微企业类别名称
         ,REPLACE(M8.TAR_VALUE_NAME,'企业','')             AS QYCZRJJCFZLMC             --078 企业出资人经济成分中类名称
         ,T7.CRDT_TOTAL_LMT_ZT                             AS SXZED                     --079 授信总额度（元）
         ,CASE WHEN T5.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）' )
                AND T5.ENT_SCALE IN ('S','X') AND T7.CRDT_TOTAL_LMT_ZT <= 10000000
               THEN '是'
               ELSE '否'
          END                                              AS SFPHXWQY                  --080 是否普惠小微企业
         ,'NA'                                             AS TJDBFS                    --081 统计担保方式
         ,CASE WHEN T8.SUB_GUA_MODE IN ('3','4','5','6','7','8','9') THEN '抵质押'
               WHEN T8.SUB_GUA_MODE IN ('2') THEN '保证'
               WHEN T8.SUB_GUA_MODE IN ('1') THEN '信用'
          END                                              AS TJDBFSMC                  --082 统计担保方式名称
         ,CASE WHEN T8.SUB_GUA_MODE = '1' THEN '信用'
               WHEN T8.SUB_GUA_MODE = '2' THEN '保证'
               WHEN T8.SUB_GUA_MODE = '3' THEN '抵押'
               WHEN T8.SUB_GUA_MODE = '4' THEN '质押'
               WHEN T8.SUB_GUA_MODE = '5' THEN '保证+抵押'
               WHEN T8.SUB_GUA_MODE = '6' THEN '保证+质押'
               WHEN T8.SUB_GUA_MODE = '7' THEN '抵押+质押'
               WHEN T8.SUB_GUA_MODE = '8' THEN '保证+抵押+质押'
               WHEN T8.SUB_GUA_MODE = '9' THEN '无担保'
          END                                              AS DBFSNBKJ                  --083 担保方式内部口径
         ,T8.MAIN_GUA_MODE                                 AS ZDBFSDM                   --084 主担保方式代码
         ,DECODE(T8.MAIN_GUA_MODE,'1','质押'
                                 ,'2','抵押'
                                 ,'3','保证'
                                 ,'4','信用'
                                 ,'不适用')                AS ZDBFS                     --085 主担保方式
         ,''                                               AS SFFDB                     --086 是否反担保
         ,''                                               AS SFGXRBZ                   --087 是否关系人保证
         ,''                                               AS SFFRZHTZ                  --088 是否法人账户透支
         ,''                                               AS SFWHBXD                   --089 是否无还本续贷
         ,''                                               AS SFXHD                     --090 是否循环贷
         ,''                                               AS HPCDFLB                   --091 汇票承兑方类别
         ,''                                               AS HPCDFLBMC                 --092 汇票承兑方类别名称
         ,''                                               AS SFYSHZ                    --093 是否银税合作
         ,''                                               AS SFZJTXZXQY                --094 是否专精特新中小企业 --待定：缺少字段
         ,DECODE(T5.ENT_CLOSE_FLG,'Y','是','否')           AS SFGTQY                    --095 是否关停企业 --待定：缺少字段
         ,''                                               AS BZXAJGCLB                 --096 保障性安居工程类别
         ,''                                               AS SDRQ                      --097 首贷日期
         ,''                                               AS SFZXSBDK                  --098 是否征信首笔贷款
         ,''                                               AS JJDKZT                    --099 借据贷款状态 --待定：缺少字段
         ,''                                               AS CLDKZT                    --100 存量贷款状态 --待定：缺少字段
         ,''                                               AS DKCZFCFS                  --101 贷款财政扶持方式 --待定：缺少字段
         ,''                                               AS SFNYCYHLTQY               --102 是否农业产业化龙头企业 --待定：缺少字段
         ,''                                               AS SFYQ                      --103 是否延期 --待定：缺少字段
         ,''                                               AS SFWLCZGSCP                --104 是否为理财子公司产品 --待定：缺少字段
         ,T8.LOAN_USEAGE                                   AS DKYT                      --109 贷款用途 --待定：缺少字段
         ,T1.AMT * U.EXRT / 10000                          AS JJFKJEZW                  --110 借据放款金额折人民币（万元）
         ,T1.BAL * U.EXRT / 10000                          AS JJYEZW                    --111 借据余额折人民币净值（万元）
         ,NVL(T11.IN_BS_OVER_INT_BAL,0) + NVL(T11.OFF_BS_OVER_INT_BAL,0)
                                                           AS QX                        --112 欠息
         ,NVL(TRIM(T11.PRIC_PNLT),0)                       AS FAX                       --113 罚息
         ,NVL(TRIM(T11.INT_PNLT),0)                        AS FUX                       --114 复息
         ,T8.CONT_AMT                                      AS HTYE                      --115 合同余额（原币种）
         ,T8.LOAN_HAPP_TYPE_CD                             AS FSLXDM                    --116 发生类型代码
         ,CASE WHEN T8.LOAN_HAPP_TYPE_CD = '0100' THEN '新增'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0101' THEN '授信条件变更'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0102' THEN '原额度续作'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0103' THEN '增额续作'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0104' THEN '减额续作'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0201' THEN '展期'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0202' THEN '借新还旧'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0204' THEN '债务重组'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0205' THEN '新借'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0206' THEN '复议'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0207' THEN '年审'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0208' THEN '变更借款人'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0209' THEN '重组贷款'
               WHEN T8.LOAN_HAPP_TYPE_CD = '0210' THEN '无还本续贷'                 
          END                                              AS FSLX                      --117 发生类型
         ,''                                               AS YHTBH                     --118 原合同编号 --待定：缺少字段
         ,''                                               AS SFCZ                      --119 是否重组
         ,''                                               AS CZRQ                      --120 重组日期
         ,CASE WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>12 THEN '中长期'
               WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>=0 THEN '短期'
               ELSE '不适用'
          END                                              AS YSQXLB                    --121 原始期限类别
         ,CASE WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>12 THEN '中长期'
               WHEN MONTHS_BETWEEN(TO_DATE(NVL(T2.BILL_EXP_DT,T3.CONT_EXP_DT),'YYYYMMDD'),TO_DATE(T1.OCCUR_DT,'YYYYMMDD'))>=0 THEN '短期'
               ELSE '不适用'
          END                                              AS YSQXLBMC                  --122 原始期限类别名称
         ,SUBSTR(T1.ENT_HLDG_TYP,1,1)                      AS QYCZRJJCFZL               --123 企业出资人经济成分中类
         ,0                                                AS TJYQBJJE                  --124 统计逾期本金金额（元）
         ,NVL(M9.TAR_VALUE_NAME,'不适用')                  AS TXGJSZZYDLMC              --126 投向高技术制造业大类名称
         ,''                                               AS TXSZJJHXCYDLMC            --128 投向数字经济核心产业大类名称
         ,T1.DATA_SRC                                      AS DEPARTMENTD               --129 归属部门
         ,''                                               AS SFTXZSCQMJXCY             --132 是否投向知识产权密集型产业
         ,T12.BILL_NUM                                     AS PJBH                      --133 票据编号
         ,T5.CUST_MGR_ID                                   AS KHZBKHJLH                 --134 客户主办客户经理号
         ,T5.CUST_TELLER_ID                                AS KHZBGYH                   --135 客户主办柜员号
         ,T5.CUST_MGR_NAME                                 AS KHZBKHJLMC                --136 客户主办客户经理名称
         ,T5.CUST_MGR_BELONG_ORG_ID                        AS KHZBKHJLSSJG              --137 客户主办客户经理所属机构
         ,''                                               AS JJZBKHJLH                 --138 借据主办客户经理号
         ,''                                               AS JJZBGYH                   --139 借据主办柜员号
         ,''                                               AS JJZBKHJLMC                --140 借据主办客户经理名称
         ,''                                               AS JJZBKHJLSSJG              --141 借据主办客户经理所属机构
         ,0                                                AS YQBJJE                    --142 逾期本金金额(元)
         ,/*SUBSTR(T1.ORG_ID,1,3)*/ -- MOD BY LIUYU 20230525
          T11.OPER_ORG_ID                                  AS JBJGBH                    --143 经办机构编号
         ,U.EXRT                                           AS DRMBZSL                   --144 对人民币折算率
         ,T1.BAL                                           AS JJYE_YBZ                  --145 借据余额（原币值）
         ,T1.AMT                                           AS FKJE_YBZ                  --146 放款金额（原币值）
         ,M10.SRC_VALUE_NAME                               AS SSGMJJHYDLMC              --147 所属国民经济行业大类名称
         ,M11.SRC_VALUE_NAME                               AS SSGMJJHYZLMC              --148 所属国民经济行业中类名称
         ,M12.SRC_VALUE_NAME                               AS SSGMJJHYXLMC              --149 所属国民经济行业小类名称
         ,M13.TAR_VALUE_NAME                               AS QYCZRJJCFXLMC             --150 企业出资人经济成分小类名称
    FROM RRP_MDL.S_OUT_DUBILL T1 --表外业务整合表
    LEFT JOIN RRP_MDL.M_LOAN_BILL_INFO T2 --票据出票表
      ON T2.RCPT_ID = T1.RCPT_ID
     AND T2.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_LGLC_INFO T3 --保函与信用证信息表
      ON T3.DUBIL_ID = T1.RCPT_ID
     AND T3.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T4 --机构表
      ON T4.ORG_ID = T1.ORG_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T5 --对公客户信息表
      ON T5.CUST_ID = T1.CUST_ID
     AND T5.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_GL_INFO T6 --总账会计科目信息表
      ON T6.SUBJ_ID = T1.SUBJ_ID
     AND T6.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO T7 --授信额度主表
      ON T7.CUST_ID = T1.CUST_ID
     AND T7.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO T8 --贷款合同信息
      ON T8.CONT_ID = NVL(T2.LOAN_CONT_ID,T3.CONT_ID)
     AND T8.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T11 -- 对公借据表
      ON T1.RCPT_ID = T11.DUBIL_ID
     AND T11.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T9 --机构表
      ON T9.ORG_ID = T11.OPER_ORG_ID
     AND T9.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T10 --标准产品表
      ON T10.PROD_ID = NVL(T2.STD_PROD_ID,T3.STD_PROD_ID)
     AND T10.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_BILL_INFO T12 -- 票据信息表
      ON T2.BILL_NO = T12.BILL_NO
     AND T12.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U --汇率表
      ON U.DATA_DT = V_P_DATE
     AND U.BASE_CUR = T1.CUR
     AND U.CNV_CUR = 'CNY'
    LEFT JOIN RRP_MDL.CODE_MAP M1  --码值表
      ON M1.SRC_CLASS_CODE = 'T0002'
     AND M1.TAR_CLASS_CODE = 'T0002'
     AND M1.MOD_FLG = 'EAST'
     AND M1.SRC_VALUE_CODE = T1.OUT_BIZ_VRTY  --表外业务品种
    LEFT JOIN RRP_MDL.CODE_MAP M2 --码值表
      ON M2.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M2.TAR_CLASS_CODE = 'P0003'
     AND M2.MOD_FLG = 'MDM'
     AND M2.SRC_VALUE_CODE = SUBSTR(TRIM(T1.CUST_BLNG_IDY),1,1) --所属行业 门类
    LEFT JOIN RRP_MDL.CODE_MAP M3 --码值表
      ON M3.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M3.TAR_CLASS_CODE = 'P0003'
     AND M3.MOD_FLG = 'MDM'
     AND M3.SRC_VALUE_CODE = SUBSTR(TRIM(T1.DIR_IDY),1,1) --投向行业 门类
    LEFT JOIN RRP_MDL.CODE_MAP M4 --码值表
      ON M4.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M4.TAR_CLASS_CODE = 'P0003'
     AND M4.MOD_FLG = 'MDM'
     AND M4.SRC_VALUE_CODE = SUBSTR(TRIM(T1.DIR_IDY),1,3) --投向行业 大类
    LEFT JOIN RRP_MDL.CODE_MAP M5 --码值表
      ON M5.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M5.TAR_CLASS_CODE = 'P0003'
     AND M5.MOD_FLG = 'MDM'
     AND M5.SRC_VALUE_CODE = SUBSTR(TRIM(T1.DIR_IDY),1,4) --投向行业 中类
    LEFT JOIN RRP_MDL.CODE_MAP M6 --码值表
      ON M6.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M6.TAR_CLASS_CODE = 'P0003'
     AND M6.MOD_FLG = 'MDM'
     AND M6.SRC_VALUE_CODE = TRIM(T1.DIR_IDY)             --投向行业 小类
    LEFT JOIN RRP_MDL.CODE_MAP M7 --码值表
      ON M7.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M7.TAR_CLASS_CODE = 'T0025'
     AND M7.MOD_FLG = 'MDM'
     AND M7.SRC_VALUE_CODE = TRIM(T1.DIR_IDY)     --高技术产业（制造业）
    LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME
                 FROM RRP_MDL.CODE_MAP --码值表
                WHERE SRC_CLASS_CODE = 'P0003' --行业类别
                  AND TAR_CLASS_CODE = 'T0025'
                  AND MOD_FLG = 'MDM'
              ) M9
      ON M9.TAR_VALUE_CODE = TRIM(T1.HIGH_TECH_IDY_MFG_CL)     --高技术产业（制造业）
    LEFT JOIN RRP_MDL.CODE_MAP M10 --码值表
      ON M10.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M10.TAR_CLASS_CODE = 'P0003'
     AND M10.MOD_FLG = 'MDM'
     AND M10.SRC_VALUE_CODE = SUBSTR(TRIM(T1.CUST_BLNG_IDY),1,3) --所属行业 大类
    LEFT JOIN RRP_MDL.CODE_MAP M11 --码值表
      ON M11.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M11.TAR_CLASS_CODE = 'P0003'
     AND M11.MOD_FLG = 'MDM'
     AND M11.SRC_VALUE_CODE = SUBSTR(TRIM(T1.CUST_BLNG_IDY),1,4) --所属行业 中类
    LEFT JOIN RRP_MDL.CODE_MAP M12 --码值表
      ON M12.SRC_CLASS_CODE = 'P0003' --行业类别
     AND M12.TAR_CLASS_CODE = 'P0003'
     AND M12.MOD_FLG = 'MDM'
     AND M12.SRC_VALUE_CODE = TRIM(T1.CUST_BLNG_IDY) --所属行业 小类
    LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME
                 FROM RRP_MDL.CODE_MAP  --码值表
                WHERE TAR_CLASS_CODE = 'C0004' --经济成分代码
                  AND SRC_CLASS_CODE = 'CD1417'
                  AND MOD_FLG = 'MDM' ) M8
      ON M8.TAR_VALUE_CODE = SUBSTR(TRIM(T5.ENT_HLDG_TYP),1,1)     --企业控股类型 中类
    LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME
                 FROM RRP_MDL.CODE_MAP  --码值表
                WHERE TAR_CLASS_CODE = 'C0004' --经济成分代码
                  AND SRC_CLASS_CODE = 'CD1417'
                  AND MOD_FLG = 'MDM' ) M13
      ON M13.TAR_VALUE_CODE = TRIM(T1.ENT_HLDG_TYP)     --企业控股类型 小类
   WHERE T1.DATA_DT = V_P_DATE
     AND T1.DATA_SRC IN ('银行承兑汇票','保函与信用证','卖断式转贴现')
     AND (NVL(T1.BAL,0) <> 0 --有余额
          OR ( NVL(T1.BAL,0) = 0 AND SUBSTR(T1.OCCUR_DT,1,4) = SUBSTR(V_P_DATE,1,4) ) --当年放款
         )
     AND NVL(T5.CUST_CL,'A') <> 'E' --剔除个体工商户
    ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'A_FGB_ACCT_LOAN是否重复'; --22

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_ACCT_LOAN T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
--插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
     V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
     ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_FGB_ACCT_LOAN;
/

