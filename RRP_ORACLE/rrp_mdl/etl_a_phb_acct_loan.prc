CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_ACCT_LOAN
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_ACCT_LOAN
  *  功能描述：零售_账务基表
  *  创建日期：20221103
  *  开发人员：韦永钊
  *  来源表：
  *  目标表：A_PHB_ACCT_LOAN --零售_账务基表
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人        修改原因
  *   1    20221107   weiyongzhao   创建过程
  *   2    20230523   liuyu         根据要求调整字段逻辑  期限月 原始期限区间名称 字段
  *   3    20230526   liuyu         S_LOAN放款日期有调整，改基表放款日期逻辑统一从M层表内借据表取数
  *   4    20230526   liuyu         根据测试反馈调整最早逾期日期逻辑
  *   5    20230606   liuyu         新增需求：增加还款频率字段
  *   6    20230609   Liuyu         自查，调整年化利息收益字段逻辑，直取S_LOAN
  *   7    20230614   liuyu         调整是否普惠小微，按照经营授信总额判断
  *   8    20240129   HYF           新增投向数字经济核心产业大类、投向数字经济核心产业大类名称逻辑映射
  *   9    20240131   hulj          涉农贷款分类名称字段剔除农副食品加工业的数据
  *   10   20240524   HYF           调整是否银税合作、是否投向高技术产业、是否投向数字经济核心产业大类逻辑
  *   11   20240529   HYF           调整投向知识产权密集型产业大类、投向知识产权密集型产业大类名称、投向战略性新兴产业门类、
  *                                 投向文化及相关产业大类、是否投向文化产业、投向高技术制造业大类名称
  *   12   20240604   YJY           新增担保方字段，仅限于网商贷产品，参考G5305网商贷担保机构逻辑
  *   13   20240615   lwb           新增执行计划调优
  *   14   20240625   YJY           调整担保合同的规则，无效的担保合同也取
  *   15   20240807   YJY           由于押品系统的贷款合同与担保合同关系表会删除已经失效的担保合同信息，会丢失当年放款当年结清的数据。需调整这部分数据从监管模型M_GUA_REL_BSN_CONT表中补这部分当年放款当年结清且失效的数据。
  *   16   20240819   YJY           优化有效和当年失效的担保机构数据
  *   17   20241119   HYF           修改循环贷，新增网商贷时点客户类型_人行、企业名称_网商贷
  *   18   20241225   HYF           调整所属行业展示为门类
  *   19   20250214   HYF           修改涉农贷款分类名称
  *   20   20250415   HYF           新增借据层企业统一社会信用代码、借据层企业名称
  *   21   20250514   HYF           新增是否退役军人标志
  *   22   20250711   HYF           合同实际期限区间名称同原始期限区间名称逻辑保持一致
  *   23   20250730   HYF           是否农户贷款取放款时农户标志
  *   24   20251113   HYF           修改投向高技术产业门类名称增加高技术服务业
  *   25   20251203   HYF           修改期限按照12个月算
  *   26   20260228   HYF           调整统计逾期本金金额
  *   27   20260324   HYF           新增无营业执照负责人标志
  ***********************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_ACCT_LOAN';
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
  V_LAST_YEAR_END    VARCHAR2(8); --上年年末      --ADD IN 20240604
  V_THIS_YEAR_BEGIN  VARCHAR2(8); --本年年初      --分析：于敬艺
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR(I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'A_PHB_ACCT_LOAN'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期
  V_LAST_YEAR_END := TO_CHAR(TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD')-1,'YYYYMMDD'); --上年年末      --ADD IN 20240604
  V_THIS_YEAR_BEGIN := TO_CHAR(TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD'),'YYYYMMDD'); --本年年初      --分析：于敬艺


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

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '零售数据_插入主表';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND*/ INTO RRP_MDL.A_PHB_ACCT_LOAN NOLOGGING
    (
          BGRQ                      --001 报告日期
         ,JYWYM                     --002 交易唯一码
         ,XDJJH                     --003 信贷借据号
         ,YWHTBH                    --004 业务合同编号
         ,ZWJGBH                    --005 账务机构编号
         ,ZWJGMC                    --006 账务机构名称
         ,KHWYM                     --007 客户唯一码
         ,KHMC                      --008 客户名称
         ,YSQSRQ                    --009 原始起始日期
         ,YSDQRQ                    --010 原始到期日期
         ,QXY                       --011 期限月
         ,YSQXLBMC                  --013 原始期限类别名称
         ,YSQXQJMC                  --015 原始期限区间名称
         ,SJDQRQ                    --016 实际到期日期
         ,SJJQRQ                    --017 实际结清日期
         ,HTJE                      --018 合同金额（元）
         ,HJKMDM                    --019 会计科目代码
         ,HJKMMC                    --020 会计科目名称
         ,DKPZ                      --021 贷款品种
         ,DKYWPZ                    --023 贷款业务品种
         ,DKYWPZMC                  --024 贷款业务品种名称
         ,WJFLMC                    --026 五级分类名称
         ,TJYQBJJE                  --027 统计逾期本金金额（元）
         ,TJYQTS                    --028 统计逾期天数（天）
         ,ZZYQRQ                    --029 最早逾期日期
         ,YQTSQJMC                  --031 逾期天数区间名称
         ,BZLB                      --032 币种类别
         ,FKJE                      --033 放款金额（元）
         ,ZXLL                      --034 执行利率（年）
         ,TJYE                      --035 统计余额（元）
         ,TJYE_W                    --036 统计余额（万元）
         ,DKZFFSMC                  --038 贷款支付方式名称
         ,DKHKFS                    --039 贷款还款方式
         ,DKHKFSMC                  --040 贷款还款方式名称
         ,SFZQ                      --041 是否展期
         ,ZQDQRQ                    --042 展期到期日期
         ,SFYQ                      --043 是否延期
         ,TJDBFSMC                  --045 统计担保方式名称
         ,ZDBFSMC                   --047 主担保方式名称
         ,CDBFSMC                   --049 从担保方式名称
         ,BJZZYQRQ                  --050 本金最早逾期日期
         ,SFXHD                     --051 是否循环贷
         ,SNDKFLMC                  --053 涉农贷款分类名称
         ,GRDKYTLBMC                --055 个人贷款用途类别名称
         ,ZXDKBS                    --056 助学贷款标识
         ,SFXYXFDK                  --057 是否校园消费贷款
         ,TJXWQYLBMC                --059 统计小微企业类别名称
         ,SFNHDK                    --060 是否农户贷款
         ,SFYSHZ                    --061 是否银税合作
         ,SFWHBXD                   --062 是否无还本续贷
         ,FSXZMC                    --064 发生性质名称
         ,TXGMJJXYMLMC              --065 投向国民经济行业门类名称
         ,TXGMJJXYDLMC              --066 投向国民经济行业大类名称
         ,TXGMJJXYZLMC              --067 投向国民经济行业中类名称
         ,TXGMJJXYXLMC              --068 投向国民经济行业小类名称
         ,TXGMJJXYXLDM              --069 投向国民经济行业小类代码
         ,TXGJSCYML                 --070 投向高技术产业门类
         ,TXGJSCYMLMC               --071 投向高技术产业门类名称
         ,SFTXGJSCY                 --072 是否投向高技术产业
         ,TXSZJJHXCYDL              --073 投向数字经济核心产业大类
         ,TXSZJJHXCYDLMC            --074 投向数字经济核心产业大类名称
         ,SFTXSZJJHXCYDL            --075 是否投向数字经济核心产业大类
         ,TXZSCQMJXCYDL             --076 投向知识产权密集型产业大类
         ,TXZSCQMJXCYDLMC           --077 投向知识产权密集型产业大类名称
         ,SFTXZSCQMJXCY             --078 是否投向知识产权密集型产业
         ,SFGYQYJSGZSJDK            --079 是否工业企业技术改造升级贷款
         ,TXZLXXXCYML               --080 投向战略性新兴产业门类
         ,TXZLXXXCYMLMC             --081 投向战略性新兴产业门类名称
         /*,SFTXXYDXXJSML             --082 是否投向新一代信息技术门类
         ,SFTXSWML                  --083 是否投向生物门类
         ,SFTXGDZBZZML              --084 是否投向高端装备制造门类
         ,SFTXXNYML                 --085 是否投向新能源门类
         ,SFTXXCLML                 --086 是否投向新材料门类
         ,SFTXXNYQCML               --087 是否投向新能源汽车门类
         ,SFTXJNHBML                --088 是否投向节能环保门类
         ,SFTXSZCYML                --089 是否投向数字创意门类
         ,SFTXXGFWML                --090 是否投向相关服务门类*/
         ,TXWHJXGCYDL               --091 投向文化及相关产业大类
         ,SFTXWHCY                  --092 是否投向文化产业
         ,SFFPXEXD                  --093 是否扶贫小额信贷
         ,LLSFGD                    --094 利率是否固定
         ,SFRZDBGSBZ                --095 是否融资担保公司保证
         ,SFZFXRZDBGSBZ             --096 是否政府性融资担保公司保证
         ,SFNHJXXNYJYZTDK           --097 是否农户及新型农业经营主体贷款
         ,CLDKZTMC                  --099 存量贷款状态名称
         ,HTSJQX                    --100 合同实际期限（天）
         ,HTSJQXQJMC                --102 合同实际期限区间名称
         ,NHLXSY                    --103 年化利息收益（元）
         ,DEPARTMENTD               --104 归属部门
         ,SFYYP                     --105 是否有押品
         ,SFYBZ                     --106 是否有保证
         ,TJYWPZMC                  --107 统计业务品种名称
         ,DKYT                      --108 贷款用途
         ,TXGJSZZYDLMC              --109 投向高技术制造业大类名称
         ,SFPHXWQY                  --110 是否普惠小微企业
         ,YQBJJE                    --111 逾期本金金额(元)
         -- ADD BY LIUYU 20230330 补录表数据验证用加所属行业字段
         ,SSGMJJHYDM                --112 所属国民经济行业代码
         ,SSGMJJHYMC                --113 所属国民经济行业名称
         ,HKPL                      --114 还款频率
         ,DBF                       --115 担保方    ADD IN 20240604
         ,WSDSDKHLX_RH              --116 网商贷时点客户类型_人行 ADD BY HYF 20241119
         ,QYMC_WSD                  --117 企业名称_网商贷 ADD BY HYF 20241119
         ,CORP_CERT_NO              --118 借据层企业统一社会信用代码 ADD BY HYF 20250415
         ,CORP_NAME                 --119 借据层企业名称
         ,EX_SERVSM_FLG             --120 退役军人标志
         ,NO_BUSLICS_PRC_FLG        --121 无营业执照负责人标志
       )
    WITH GUARTOR_NAME_TMP1 AS     --多对多，取担保公司名称包含“融资担保”的数据
          ( SELECT /*+ materialize*/ 
                   B.LOAN_CONT_ID    AS LOAN_CONT_ID,
                   LISTAGG(A.GUARTOR_NAME,',') WITHIN GROUP(ORDER BY B.LOAN_CONT_ID) AS GUARTOR_NAME  --担保机构名称
              FROM RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO A    --联合网贷担保合同信息
             INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_GUAR_CONT_RELA B  --联合网贷贷款与担保合同关系
                ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
               AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
             WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
               AND A.GUARTOR_NAME LIKE '%融资担保%'
             GROUP BY B.LOAN_CONT_ID  ),
  -- MOD BY YJY IN 20240807 处理当年失效的担保合同
  GUARTOR_NAME_TMP2 AS   
        (  SELECT /*+ materialize*/ 
                   LOAN_CONT_ID
                  ,GUARTOR_NAME
             FROM (SELECT T1.BIZ_CONT_ID        AS LOAN_CONT_ID      
                         ,T2.GUARTOR_NAME       AS GUARTOR_NAME   
                         ,ROW_NUMBER() OVER(PARTITION BY T1.BIZ_CONT_ID ORDER BY T1.DATA_DT DESC) AS RN
                     FROM RRP_MDL.M_GUA_REL_BSN_CONT  T1  
                    INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO T2 
                       ON T1.GUA_CONT_ID =T2.GUAR_CONT_ID
                      AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                      AND T2.GUARTOR_NAME LIKE '%融资担保%'
                    WHERE T1.DATA_DT >= V_THIS_YEAR_BEGIN
                      AND T1.DATA_DT < V_P_DATE
                      AND SUBSTR(T1.GUA_REL_RLV_DT,0,4)=SUBSTR(V_P_DATE,0,4)
                      AND T1.DATA_SRC ='联合网贷' )
            WHERE RN=1 ),
   GUARTOR_NAME_TMP3 AS
         ( SELECT /*+ materialize*/
                 LOAN_CONT_ID
                 ,GUARTOR_NAME
             FROM GUARTOR_NAME_TMP1
           UNION ALL
           SELECT LOAN_CONT_ID
                 ,GUARTOR_NAME
             FROM GUARTOR_NAME_TMP2  T1 
            WHERE T1.LOAN_CONT_ID NOT IN  (SELECT T2.LOAN_CONT_ID  
                                             FROM GUARTOR_NAME_TMP1  T2)),  --MOD BY YJY IN 20240819     
   M_LOAN_IN_DUBILL_INFO_TMP AS
         ( SELECT /*+ materialize*/
                   RCPT_ID           AS RCPT_ID         
                  ,LOAN_ACT_DSTR_DT  AS LOAN_ACT_DSTR_DT
                  ,LOAN_ACT_EXP_DT   AS LOAN_ACT_EXP_DT
                  ,ACT_END_DT        AS ACT_END_DT
                  ,LOAN_PROD_ID      AS LOAN_PROD_ID
                  ,LOAN_PROD_NM      AS LOAN_PROD_NM
                  ,EXEC_RATE         AS EXEC_RATE
                  ,RENEW_EXP_DAY     AS RENEW_EXP_DAY
                  ,PRIN_OVD_DT       AS PRIN_OVD_DT
                  ,FIXED_INT_MARK    AS FIXED_INT_MARK
                  ,LOAN_USEAGE       AS LOAN_USEAGE
             FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO 
            WHERE DATA_DT = V_P_DATE
              AND DATA_SRC IN ('零售贷款','联合网贷')),
   M_CUST_IND_INFO_TMP AS
         ( SELECT /*+ materialize*/  
                  CUST_NM 
                  ,CUST_ID
             FROM RRP_MDL.M_CUST_IND_INFO 
            WHERE DATA_DT = V_P_DATE ),     
   M_GL_INFO_TMP AS 
         ( SELECT /*+ materialize*/ 
                  SUBJ_NM 
                 ,SUBJ_ID
           FROM RRP_MDL.M_GL_INFO 
           WHERE DATA_DT = V_P_DATE ),
   M_LOAN_CONT_INFO_TMP AS 
         ( SELECT   /*+ materialize*/ 
                  CONT_AMT 
                 ,CONT_ID
                 ,LOAN_HAPP_TYPE_CD
                 ,CONT_EXP_DT
            FROM RRP_MDL.M_LOAN_CONT_INFO 
           WHERE DATA_DT = V_P_DATE ),
   UNITE_WL_DUBIL_INFO_TMP1 AS
         ( SELECT /*+ materialize*/  
                  DUBIL_ID 
                 ,CONT_ID
                 ,CASE WHEN ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') 
                       THEN 'DT' 
                       ELSE 'NC' 
                   END RQ_DAY
            FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO   
           WHERE ETL_DT IN (TO_DATE(V_P_DATE,'YYYYMMDD'),TO_DATE(V_LAST_YEAR_END,'YYYYMMDD'))),
   G0107_REMAPPING_BL_TMP AS 
         ( SELECT /*+ materialize*/ 
                  DISTINCT CYML
                 ,M_CORE
                 ,M_NAME
                 ,CODE
                 ,NAME
                 ,SFDX
            FROM RRP_MDL.M_DICT_G0107_REMAPPING_BL
           WHERE TYPE_CODE = 'G010701'),
   ADD_LS_014_FINANCE_GUARAN_TMP AS 
         (  SELECT /*+ materialize*/SFNHJXXNYJYZTDK,JYWYM
              FROM (SELECT SFNHJXXNYJYZTDK
                           ,JYWYM
                           ,ROW_NUMBER()OVER(PARTITION BY JYWYM ORDER BY JYWYM ) AS RN
                      FROM RRP_MDL.M_ADD_LS_014_FINANCE_GUARAN 
                     WHERE DATA_DATE = V_P_DATE ) T
             WHERE T.RN=1 ),
   TMP_S_G13_BASE as 
         ( SELECT /*+ materialize*/CREDNO
             FROM RRP_MDL.S_G13_BASE 
            WHERE DATA_DT = V_P_DATE
              AND CREDNO IS NOT NULL
            GROUP BY CREDNO )   
   SELECT /*+USE_HASH(T1,T2,T3,T4,T5,T6,T7,T8,T9,G,U,M1,M2,M3,M4,M5,M6,M8,M11,T10,T11,T12)*/
          T1.DATA_DT                                  AS BGRQ                      --001 报告日期
         ,T1.RCPT_ID                                  AS JYWYM                     --002 交易唯一码
         ,T1.RCPT_ID                                  AS XDJJH                     --003 信贷借据号
         ,T1.CONT_ID                                  AS YWHTBH                    --004 业务合同编号
         ,T1.ORG_ID                                   AS ZWJGBH                    --005 账务机构编号
         ,T3.ORG_NM                                   AS ZWJGMC                    --006 账务机构名称
         ,T1.CUST_ID                                  AS KHWYM                     --007 客户唯一码
         ,T4.CUST_NM                                  AS KHMC                      --008 客户名称
         ,T2.LOAN_ACT_DSTR_DT                         AS YSQSRQ                    --009 原始起始日期
         ,T1.LOAN_ORIG_EXP_DT                         AS YSDQRQ                    --010 原始到期日期
/*         ,CASE WHEN T1.DATA_SRC = '零售贷款'
               THEN (CASE WHEN T1.RCPT_ID IN ('HT11012018120500005J001','HT11012018120500006J001'
                                           ,'HT11012018120600037J001','HT11012018120700005J001'
                                           ,'HT11012018120700019J001'
                                           ,'HT11012018120700052J001','HT11012018121200032J001'
                                           ,'HT11012018121300019J001','HT11012018121300063J001'
                                           ,'HT11012018121400010J001')
                         THEN 12  --经业务确认，这11笔借据为短期，写定期限类型 'HT11012018120700006J001' 剔除默认为短期，业务确认这笔为中长期
                         ELSE MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD'))
                    END)
               WHEN T1.DATA_SRC = '联合网贷'
               THEN (TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30
          END                                        AS QXY                       --011 期限月  -- MOD BY LIUYU 20230523 调整期限月逻辑*/
         ,MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD'))
                                                     AS QXY                       --011 期限月  -- MOD BY HYF 20251203 调整期限月逻辑
         ,CASE WHEN T1.LOAN_TERM IN ('S') THEN '短期'
               WHEN T1.LOAN_TERM IN ('M','L') THEN '中长期'
               ELSE '不适用'
          END                                        AS YSQXLBMC                  --013 原始期限类别名称
         ,CASE WHEN T1.ORIG_TERM_CODE = '3M' THEN '三个月以内'
               WHEN T1.ORIG_TERM_CODE = '6M' THEN '三个月至六个月'
               WHEN T1.ORIG_TERM_CODE = '12M' THEN '六个月至一年'
               WHEN T1.ORIG_TERM_CODE = '2Y' THEN '一年至两年'
               WHEN T1.ORIG_TERM_CODE = '3Y' THEN '两年至三年'
               WHEN T1.ORIG_TERM_CODE = '5Y' THEN '三年至五年'
               WHEN T1.ORIG_TERM_CODE = '5YA' THEN '五年以上'
               ELSE '不适用'
          END                                        AS YSQXQJMC                  --015 原始期限区间名称 -- MOD BY LIUYU 20230523 调整原始期限区间名称逻辑
         ,T2.LOAN_ACT_EXP_DT                         AS SJDQRQ                    --016 实际到期日期
         ,T2.ACT_END_DT                              AS SJJQRQ                    --017 实际结清日期
         ,T7.CONT_AMT * U.EXRT                       AS HTJE                      --018 合同金额（元）
         ,T1.SUBJ_ID                                 AS HJKMDM                    --019 会计科目代码
         ,T5.SUBJ_NM                                 AS HJKMMC                    --020 会计科目名称
         ,CASE WHEN T1.LOAN_BIZ_TYP LIKE '0102%' THEN '个人生产经营性贷款'
               --信用卡汽车分期
               --信用卡房屋装修分期
               --信用卡其他
               WHEN T1.LOAN_BIZ_TYP = '010301' THEN '汽车'
               WHEN T1.LOAN_BIZ_TYP = '010101' THEN '住房按揭贷款'
               WHEN T1.LOAN_BIZ_TYP = '010302' THEN '房屋装修贷款'
               WHEN T1.LOAN_BIZ_TYP = '010303' THEN '大件耐用消费品贷款'
               WHEN T1.LOAN_BIZ_TYP IN ('010402','010403') THEN '国家助学贷款'
               WHEN T1.LOAN_BIZ_TYP = '010404' THEN '生源地助学贷款'
               WHEN T1.LOAN_BIZ_TYP = '010405' THEN '商业性助学贷款'
               --校园消费贷款
               ELSE '其他'
          END                                        AS DKPZ                      --021 贷款品种
         ,T2.LOAN_PROD_ID                            AS DKYWPZ                    --023 贷款业务品种
         ,T2.LOAN_PROD_NM                            AS DKYWPZMC                  --024 贷款业务品种名称
         ,CASE WHEN T1.LVL5_CL = '01' THEN '正常类'
               WHEN T1.LVL5_CL = '02' THEN '关注类'
               WHEN T1.LVL5_CL = '03' THEN '次级类'
               WHEN T1.LVL5_CL = '04' THEN '可疑类'
               WHEN T1.LVL5_CL = '05' THEN '损失类'
          END                                        AS WJFLMC                    --026 五级分类名称
         ,CASE WHEN T1.OVD_DAYS <=0 THEN 0
               WHEN T1.OVD_DAYS > 0 AND T1.OVD_DAYS <= 90 
                AND SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104')  --个人消费
                AND T1.GXH_PAY_TYPE IN ('1', '2', '6', '7', '8', '9', '11')
                AND T1.GXH_PAY_FREQ = 'M' --还款频率 按月还款
               THEN T1.OVD_PRIN_BAL * U.EXRT --逾期本金余额
               WHEN T1.OVD_DAYS > 0--modify by lwb
               THEN T1.LOAN_NET_VAL * U.EXRT --贷款余额
               ELSE 0
          END                                        AS TJYQBJJE                  --027 统计逾期本金金额（元）
         ,T1.OVD_DAYS                                AS TJYQTS                    --028 统计逾期天数（天）
         ,/*LEAST(T2.PRIN_OVD_DT,T2.INT_OVD_DT)*/
          CASE WHEN NVL(T1.OVD_DAYS,0) > 0 
               THEN TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - T1.OVD_DAYS,'YYYYMMDD')
          END                                        AS ZZYQRQ                    --029 最早逾期日期 -- MOD BY LIUYU 20230526
         ,CASE WHEN T1.OVD_DAYS < = 0 THEN '未逾期'
               WHEN T1.OVD_DAYS > 0   AND T1.OVD_DAYS < = 30  THEN '逾期30天以内'
               WHEN T1.OVD_DAYS > 30  AND T1.OVD_DAYS < = 60  THEN '逾期31天到60天'
               WHEN T1.OVD_DAYS > 60  AND T1.OVD_DAYS < = 90  THEN '逾期61天到90天'
               WHEN T1.OVD_DAYS > 90  AND T1.OVD_DAYS < = 180 THEN '逾期91天到180天'                 
               WHEN T1.OVD_DAYS > 180 AND T1.OVD_DAYS < = 270 THEN '逾期181天到270天'
               WHEN T1.OVD_DAYS > 270 AND T1.OVD_DAYS < = 360 THEN '逾期271天到360天'
               WHEN T1.OVD_DAYS > 360 THEN '逾期361天以上'
          END                                        AS YQTSQJMC                  --031 逾期天数区间名称
         ,DECODE(T1.CUR,'CNY','人民币','外币')       AS BZLB                      --032 币种类别
         ,T1.LOAN_AMT * U.EXRT                       AS FKJE                      --033 放款金额（元）
         ,T2.EXEC_RATE                               AS ZXLL                      --034 执行利率（年）
         ,T1.LOAN_BAL * U.EXRT                       AS TJYE                      --035 统计余额（元）
         ,T1.LOAN_BAL * U.EXRT / 10000               AS TJYE_W                    --036 统计余额（万元）
         ,CASE WHEN T1.DATA_SRC = '联合网贷' OR T1.STD_PROD_ID = '551612310' 
                 OR T1.DSBR_MODE = '01' THEN '自主支付'
               WHEN T1.DSBR_MODE = '02' THEN '受托支付'
               ELSE '不适用'
          END                                        AS DKZFFSMC                  --038 贷款支付方式名称
         ,T1.GXH_PAY_TYPE                            AS DKHKFS                    --039 贷款还款方式
         ,M11.SRC_VALUE_NAME                         AS DKHKFSMC                  --040 贷款还款方式名称
         ,DECODE(T1.EXTN_FLG,'Y','是','否')          AS SFZQ                      --041 是否展期
         ,CASE WHEN T1.EXTN_FLG = 'Y' 
               THEN T2.RENEW_EXP_DAY 
               ELSE NULL 
          END                                        AS ZQDQRQ                    --042 展期到期日期
         ,'否'                                       AS SFYQ                      --043 是否延期
         ,DECODE(T1.TJDBFS,'DZY','抵质押'
                          ,'BZ','保证'
                          ,'XY','信用'
                          ,'不适用')                 AS TJDBFSMC                  --045 统计担保方式名称
         ,DECODE(T1.GUA_MODE,'1','抵押'
                            ,'2','质押'
                            ,'3','保证'
                            ,'4','信用'
                            ,'不适用')               AS ZDBFSMC                   --047 主担保方式名称
         ,DECODE(T1.SUB_GUA_MODE,'A','抵押'
                                ,'B','质押'
                                ,'C','保证'
                                ,'D','信用'
                                ,'不适用')           AS CDBFSMC                   --049 从担保方式名称
         --,M12.SRC_VALUE_NAME        AS CDBFSMC                   --049 从担保方式名称
         ,T2.PRIN_OVD_DT                             AS BJZZYQRQ                  --050 本金最早逾期日期
         ,DECODE(T1.REV_LOAN_FLG,'Y','是','否')      AS SFXHD                     --051 是否循环贷
         ,CASE WHEN T1.FKSSNBZ = 'Y' THEN '农户涉农'
               WHEN T1.FKSSNBZ = 'N' 
                AND T8.RCPT_ID IS NOT NULL 
                AND T8.AGR_REL_LOAN_BIZ_TYP='A'
               THEN '非农户个人涉农'
               ELSE '非涉农'
          END                                         AS SNDKFLMC                   --053 涉农贷款分类名称--剔除农副食品加工业的  20102% --个人经营性贷款
         ,CASE WHEN T1.LOAN_BIZ_TYP LIKE '0102%' THEN '个人经营性贷款'
               --信用卡汽车分期
               --信用卡房屋装修分期
               --信用卡其他
               WHEN T1.LOAN_BIZ_TYP = '010301' THEN '汽车'
               WHEN T1.LOAN_BIZ_TYP = '010101' THEN '住房按揭贷款'
               WHEN T1.LOAN_BIZ_TYP = '010302' THEN '房屋装修贷款'
               WHEN T1.LOAN_BIZ_TYP = '010303' THEN '大件耐用消费品贷款'
               WHEN T1.LOAN_BIZ_TYP IN ('010402','010403') THEN '国家助学贷款'
               WHEN T1.LOAN_BIZ_TYP = '010404' THEN '生源地助学贷款'
               WHEN T1.LOAN_BIZ_TYP = '010405' THEN '商业性助学贷款'
               --校园消费贷款
               ELSE '其他'
          END                                         AS GRDKYTLBMC                --055 个人贷款用途类别名称
         ,'非助学'                                    AS ZXDKBS                    --056 助学贷款标识
         ,'否'                                        AS SFXYXFDK                  --057 是否校园消费贷款
         ,CASE WHEN T1.LOAN_BIZ_TYP LIKE '0102%' 
               THEN  -- 取经营贷款客户
                   CASE WHEN T1.OPR_CUST_TYP = 'A' THEN '个体工商户'
                        WHEN T1.OPR_CUST_TYP = 'B' THEN '小微企业主'
                        WHEN T1.OPR_CUST_TYP = 'Z' THEN '其他个人经营客户'
                        ELSE '其他个人经营客户'
                   END
              ELSE '不适用'
          END                                         AS TJXWQYLBMC                --059 统计小微企业类别名称
         ,DECODE(T1.FKSSNBZ,'Y','是','否')            AS SFNHDK                    --060 是否农户贷款 MDF 20250730
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP,0,4) = '0102' 
                AND T1.BANK_TAX_COOP_LOAN_FLG = 'Y'
               THEN '是' ELSE '否' END                AS SFYSHZ                    --061 是否银税合作
         ,DECODE(T1.NON_REPY_PRIN_RENEW_FLG,'Y','是','否')
                                                      AS SFWHBXD                   --062 是否无还本续贷
         ,CASE WHEN T7.LOAN_HAPP_TYPE_CD = '0100' THEN '新增'
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
               WHEN T7.LOAN_HAPP_TYPE_CD = '0209' THEN '续期'
               WHEN T7.LOAN_HAPP_TYPE_CD = '0210' THEN '无还本续贷'
          END                                         AS FSXZMC                    --064 发生性质名称
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '不适用'
               ELSE NVL(M3.SRC_VALUE_NAME,'不适用')
          END                                         AS TXGMJJXYMLMC              --065 投向国民经济行业门类名称
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '不适用'
               ELSE NVL(M4.SRC_VALUE_NAME,'不适用')
          END                                         AS TXGMJJXYDLMC              --066 投向国民经济行业大类名称
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '不适用'
               ELSE NVL(M5.SRC_VALUE_NAME,'不适用')
          END                                         AS TXGMJJXYZLMC              --067 投向国民经济行业中类名称
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '不适用'
               ELSE NVL(M6.SRC_VALUE_NAME,'不适用')
          END                                         AS TXGMJJXYXLMC              --068 投向国民经济行业小类名称
         ,T1.LOAN_DIR_IDY                             AS TXGMJJXYXLDM              --069 投向国民经济行业小类代码
         ,''                                          AS TXGJSCYML                 --070 投向高技术产业门类
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '否'
               WHEN T1.HIGH_TECH_IDY = 'Y' THEN '高技术制造业'
               WHEN T1.HIGH_TECH_IDY_SER_FLG = 'Y' THEN '高技术服务业'
               ELSE '不适用'
          END                                         AS TXGJSCYMLMC               --071 投向高技术产业门类名称
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '否'
               WHEN T1.HIGH_TECH_IDY = 'Y' THEN '是'
               WHEN T1.HIGH_TECH_IDY_SER_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                         AS SFTXGJSCY                 --072 是否投向高技术产业
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN ''
          ELSE T1.DIGI_ECON_CORE_IDY END              AS TXSZJJHXCYDL              --073 投向数字经济核心产业大类 ADD BY HYF 20240129
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '不适用'
               WHEN T1.DIGI_ECON_CORE_IDY = '01' THEN '数字产品制造业' --数字产品制造业
               WHEN T1.DIGI_ECON_CORE_IDY = '02' THEN '数字产品服务业' --数字产品服务业
               WHEN T1.DIGI_ECON_CORE_IDY = '03' THEN '数字技术应用业' --数字技术应用业
               WHEN T1.DIGI_ECON_CORE_IDY = '04' THEN '数字要素驱动业' --数字要素驱动业
               WHEN T1.DIGI_ECON_CORE_IDY = '05' THEN '数字化效率提升业' --数字化效率提升业
               WHEN T1.DIGI_ECON_CORE_IDY = '06' THEN '非数据经济核心产业' --非数据经济核心产业
               ELSE '不适用' --不适用
           END                                       AS TXSZJJHXCYDLMC            --074 投向数字经济核心产业大类名称 ADD BY HYF 20240129
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '否'
               WHEN T1.DIGI_ECON_CORE_IDY IN ('01','02','03','04','05') THEN '是'
               ELSE '否'
          END                                        AS SFTXSZJJHXCYDL            --075 是否投向数字经济核心产业大类
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN ''
               ELSE T1.INTEL_PROP_FLG END            AS TXZSCQMJXCYDL             --076 投向知识产权密集型产业大类
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '不适用'
               ELSE DECODE(T1.INTEL_PROP_FLG,'01','信息通信技术制造业' --信息通信技术制造业
                            ,'02','信息通信技术服务业' --信息通信技术服务业
                            ,'03','新装备制造业' --新装备制造业
                            ,'04','新材料制造业' --新材料制造业
                            ,'05','医药医疗产业' --医药医疗产业
                            ,'06','环保产业' --环保产业
                            ,'07','研发、设计和技术服务业' --研发、设计和技术服务业
                            ,'不适用') END           AS TXZSCQMJXCYDLMC           --077 投向知识产权密集型产业大类名称
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '否'
               WHEN T1.IP_CONC_IDY = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFTXZSCQMJXCY             --078 是否投向知识产权密集型产业
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '否'
               WHEN T1.IDY_TRNST_UPG_FLG = 'Y' THEN '是'
               ELSE '否'
          END                                        AS SFGYQYJSGZSJDK            --079 是否工业企业技术改造升级贷款
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN ''
               ELSE T1.STRTG_EMER_IDY_TYP END        AS TXZLXXXCYML               --080 投向战略性新兴产业门类
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '不适用'
               ELSE DECODE(T1.STRTG_EMER_IDY_TYP,'C','节能环保产业' --节能环保
                            ,'D','新一代信息技术产业' --新一代信息技术
                            ,'E','生物产业' --生物
                            ,'F','高端装备制造产业' --高端装备制造
                            ,'G','新能源产业' --新能源
                            ,'H','新材料产业' --新材料
                            ,'I','新能源汽车产业' --新能源汽车
                            ,'J','数字创意产业' --数字创意
                            ,'K','相关服务产业' --相关服务
                            ,'不适用') END            AS TXZLXXXCYMLMC   --081 投向战略性新兴产业门类名称
         /*,'' AS SFTXXYDXXJSML             --082 是否投向新一代信息技术门类 --待定：缺少口径
         ,'' AS SFTXSWML                  --083 是否投向生物门类 --待定：缺少口径
         ,'' AS SFTXGDZBZZML              --084 是否投向高端装备制造门类 --待定：缺少口径
         ,'' AS SFTXXNYML                 --085 是否投向新能源门类 --待定：缺少口径
         ,'' AS SFTXXCLML                 --086 是否投向新材料门类 --待定：缺少口径
         ,'' AS SFTXXNYQCML               --087 是否投向新能源汽车门类 --待定：缺少口径
         ,'' AS SFTXJNHBML                --088 是否投向节能环保门类 --待定：缺少口径
         ,'' AS SFTXSZCYML                --089 是否投向数字创意门类 --待定：缺少口径
         ,'' AS SFTXXGFWML                --090 是否投向相关服务门类 --待定：缺少口径*/
         --字段整合 不再使用
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN ''
               ELSE T1.CUL_AND_RELA_PPTY_TYPE_CD END AS TXWHJXGCYDL           --091 投向文化及相关产业大类
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '否'
               ELSE DECODE(T1.CUL_PROPERTY_FLG,'Y','是','否') END AS SFTXWHCY     --092 是否投向文化产业
         ,'否'                                       AS SFFPXEXD                  --093 是否扶贫小额信贷
         ,CASE WHEN T1.STD_PROD_ID IN ('202010100003') THEN '是'
               ELSE DECODE(T2.FIXED_INT_MARK,'0','是','否')
          END                                        AS LLSFGD                    --094 利率是否固定
         ,DECODE(T1.FIN_GUA_ORG_LOAN_FLG,'Y','是','否')
                                                     AS SFRZDBGSBZ                --095 是否融资担保公司保证
         ,DECODE(T1.GOV_FIN_GUA_LOAN_FLG,'Y','是','否')
                                                     AS SFZFXRZDBGSBZ             --096 是否政府性融资担保公司保证
         ,DECODE(T9.SFNHJXXNYJYZTDK,'Y','是','否')   AS SFNHJXXNYJYZTDK           --097 是否农户及新型农业经营主体贷款
         ,CASE WHEN T1.EXTN_FLG = 'Y' THEN '展期'
               WHEN T1.LOAN_NET_VAL = 0 THEN '结清'
               WHEN T1.RCPT_STAT IN ('A','C','D') THEN '正常'
               WHEN T1.RCPT_STAT = 'B' THEN '逾期'
          END                                        AS CLDKZTMC                  --099 存量贷款状态名称
         ,ABS(TO_DATE(T7.CONT_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD'))
                                                     AS HTSJQX                    --100 合同实际期限（天）
/*         ,CASE WHEN T1.DATA_SRC = '零售贷款' 
               THEN ( CASE WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                               ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 3 THEN '三个月以内'
                           WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                               ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 6 THEN '三个月至六个月'
                           WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                               ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 12 THEN '六个月至一年'
                           WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                               ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 24 THEN '一年至两年'
                           WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                               ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 36 THEN '两年至三年'
                           WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                               ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 60 THEN '三年至五年'
                           WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                               ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) > 60 THEN '五年以上'
                      ELSE '不适用' END )
               WHEN T1.DATA_SRC = '联合网贷'
               THEN ( CASE WHEN (TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                 -TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD'))/30 <= 3 THEN '三个月以内'
                           WHEN (TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                 -TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD'))/30 <= 6 THEN '三个月至六个月'
                           WHEN (TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                 -TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD'))/30 <= 12 THEN '六个月至一年'
                           WHEN (TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                 -TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD'))/30 <= 24 THEN '一年至两年'
                           WHEN (TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                 -TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD'))/30 <= 36 THEN '两年至三年'
                           WHEN (TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                 -TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD'))/30 <= 60 THEN '三年至五年'
                           WHEN (TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                 -TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD'))/30 > 60 THEN '五年以上'
                        ELSE '不适用' END )                     
          END                                      AS HTSJQXQJMC                --102 合同实际期限区间名称*/
         ,CASE WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                   ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 3 THEN '三个月以内'
               WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                   ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 6 THEN '三个月至六个月'
               WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                   ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 12 THEN '六个月至一年'
               WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                   ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 24 THEN '一年至两年'
               WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                   ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 36 THEN '两年至三年'
               WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                   ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 60 THEN '三年至五年'
               WHEN MONTHS_BETWEEN(TO_DATE(T7.CONT_EXP_DT, 'YYYY-MM-DD')
                                   ,TO_DATE(T2.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) > 60 THEN '五年以上'
          ELSE '不适用' END                        AS HTSJQXQJMC                --102 合同实际期限区间名称
         ,T1.INCOME_ANNUAL                         AS NHLXSY                    --103 年化利息收益（元）
         ,T1.DATA_SRC                              AS DEPARTMENTD               --104 归属部门
         ,CASE WHEN T6.CREDNO IS NOT NULL THEN '是'
               ELSE '否'
          END                                      AS SFYYP                     --105 是否有押品
         ,CASE WHEN T1.GUA_MODE = '3' THEN '是'
               ELSE '否'
          END                                      AS SFYBZ                     --106 是否有保证
         ,M1.SRC_VALUE_NAME                        AS TJYWPZMC                  --107 统计业务品种名称
         ,T2.LOAN_USEAGE                           AS DKYT                      --108 贷款用途
         ,CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199') THEN '不适用'
               ELSE DECODE(T1.HIGH_TECH_IDY_MFG_CL,'01','医药制造业' --医药制造业
                            ,'02','航空、航天器及设备制造业' --航空、航天器及设备制造业
                            ,'03','电子及通信设备制造业' --电子及通信设备制造业
                            ,'04','计算机及办公设备制造业' --计算机及办公设备制造业
                            ,'05','医疗仪器设备及仪器仪表制造业' --医疗仪器设备及仪器仪表制造业
                            ,'06','信息化学品制造业' --信息化学品制造业
                            ,'不适用') END
                                                  AS TXGJSZZYDLMC              --109 投向高技术制造业大类名称
         ,CASE WHEN T1.LOAN_BIZ_TYP LIKE '0102%'
                AND T1.OPR_CUST_TYP IN ('A','B')
                AND T1.OPR_CRDT_TOT_AMT <= 10000000   -- 取经营额度判断
               THEN '是'
               ELSE '否'
          END                                     AS SFPHXWQY                  --110 是否普惠小微企业
         ,T1.OVD_PRIN_BAL * U.EXRT                AS YQBJJE                    --111 逾期本金金额(元)
         ,T1.CUST_BLNG_IDY                        AS SSGMJJHYDM                --112 所属国民经济行业代码
         ,M2.SRC_VALUE_NAME                       AS SSGMJJHYMC                --113 所属国民经济行业名称
         ,CASE WHEN T1.GXH_PAY_FREQ = 'M' THEN '按月还款'
               ELSE T1.GXH_PAY_FREQ --码值不全，暂时取源码值
          END                                     AS HKPL                      --114 还款频率
         ,CASE WHEN T1.DATA_SRC= '联合网贷'
               THEN T12.GUARTOR_NAME
               ELSE '不涉及'
          END                                     AS DBF                       --115 担保方    ADD IN 20240604
         ,CASE WHEN T1.OPR_CUST_TYP_WSD_RH = 'A' THEN '个体工商户'
               WHEN T1.OPR_CUST_TYP_WSD_RH = 'B' THEN '小微企业主'
          END                                     AS OPR_CUST_TYP_WSD_RH       --116 时点客户类型_人行
         ,T1.CUST_NM_WSD                          AS QYMC_WSD                  --117 企业名称_网商贷
         ,T1.CORP_CERT_NO                         AS CORP_CERT_NO              --118 借据层企业统一社会信用代码
         ,T1.CORP_NAME                            AS CORP_NAME                 --119 借据层企业名称
         ,CASE WHEN T1.EX_SERVSM_FLG = 'Y' THEN '是'
          ELSE '否' END                           AS EX_SERVSM_FLG             --120 退役军人标志
         ,CASE WHEN T1.NO_BUSLICS_PRC_FLG = 'Y' THEN '是'
          ELSE '否' END                           AS NO_BUSLICS_PRC_FLG        --121 无营业执照负责人标志            
    FROM RRP_MDL.S_LOAN T1  --贷款业务整合表
    LEFT JOIN M_LOAN_IN_DUBILL_INFO_TMP T2  --表内借据信息
      ON T2.RCPT_ID = T1.RCPT_ID
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3  --机构表
      ON T3.ORG_ID = T1.ORG_ID
     AND T3.DATA_DT = V_P_DATE
    LEFT JOIN M_CUST_IND_INFO_TMP T4  --个人客户信息
      ON T4.CUST_ID = T1.CUST_ID
    LEFT JOIN M_GL_INFO_TMP T5    --总账会计科目信息表
      ON T5.SUBJ_ID = T1.SUBJ_ID
    LEFT JOIN TMP_S_G13_BASE T6   --抵质押物价值拆分表
      ON T6.CREDNO = T1.RCPT_ID
    LEFT JOIN M_LOAN_CONT_INFO_TMP T7   --贷款合同信息
      ON T7.CONT_ID=T1.CONT_ID
    LEFT JOIN RRP_MDL.S_LOAN_AGR_REL T8   -- 涉农贷款S层表
     ON T8.RCPT_ID = T1.RCPT_ID
    AND T8.DATA_DT = V_P_DATE
    LEFT JOIN ADD_LS_014_FINANCE_GUARAN_TMP  T9  --补录表-零售-融资担保机构代偿模型（G5305）
      ON T9.JYWYM = T1.RCPT_ID
    LEFT JOIN G0107_REMAPPING_BL_TMP G     --高技术产业
      ON G.CODE = T1.LOAN_DIR_IDY
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U   --汇率表
      ON U.DATA_DT = V_P_DATE
     AND U.BASE_CUR = T1.CUR
     AND U.CNV_CUR = 'CNY'
    LEFT JOIN RRP_MDL.CODE_MAP M1   --码值表
      ON M1.TAR_CLASS_CODE = 'T0001' --贷款类型
     AND M1.SRC_CLASS_CODE = 'T0001'
     AND M1.MOD_FLG = 'EAST'
     AND M1.SRC_VALUE_CODE = T1.LOAN_BIZ_TYP
    LEFT JOIN RRP_MDL.CODE_MAP M2  --码值表
      ON M2.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M2.SRC_CLASS_CODE = 'P0003'
     AND M2.MOD_FLG = 'MDM'
     AND M2.SRC_VALUE_CODE = TRIM(T1.CUST_BLNG_IDY)  --所属行业 门类 
    LEFT JOIN RRP_MDL.CODE_MAP M3  --码值表
      ON M3.TAR_CLASS_CODE = 'P0003'  --行业类别
     AND M3.SRC_CLASS_CODE = 'P0003'
     AND M3.MOD_FLG = 'MDM'
     AND M3.SRC_VALUE_CODE = SUBSTR(TRIM(T1.LOAN_DIR_IDY),1,1)   --投向行业 门类
    LEFT JOIN RRP_MDL.CODE_MAP M4  --码值表
      ON M4.TAR_CLASS_CODE = 'P0003'  --行业类别
     AND M4.SRC_CLASS_CODE = 'P0003'
     AND M4.MOD_FLG = 'MDM'
     AND M4.SRC_VALUE_CODE = SUBSTR(TRIM(T1.LOAN_DIR_IDY),1,3)  --投向行业 大类
    LEFT JOIN RRP_MDL.CODE_MAP M5  --码值表
      ON M5.TAR_CLASS_CODE = 'P0003'  --行业类别
     AND M5.SRC_CLASS_CODE = 'P0003'
     AND M5.MOD_FLG = 'MDM'
     AND M5.SRC_VALUE_CODE = SUBSTR(TRIM(T1.LOAN_DIR_IDY),1,4)  --投向行业 中类
    LEFT JOIN RRP_MDL.CODE_MAP M6  --码值表
      ON M6.TAR_CLASS_CODE = 'P0003' --行业类别
     AND M6.SRC_CLASS_CODE = 'P0003'
     AND M6.MOD_FLG = 'MDM'
     AND M6.SRC_VALUE_CODE = TRIM(T1.LOAN_DIR_IDY)            --投向行业 小类  
    /*LEFT JOIN RRP_MDL.CODE_MAP M8 
           ON M8.TAR_CLASS_CODE = 'C0004' 
          AND M8.SRC_CLASS_CODE = 'C0004'
          AND M8.MOD_FLG = 'BFD'
          AND M8.SRC_VALUE_CODE = SUBSTR(TRIM(T1.ENT_HLDG_TYP),1,1)    */ 
    LEFT JOIN RRP_MDL.CODE_MAP M11  --码值表
      ON M11.TAR_CLASS_CODE = 'CD1072'  --还款方式
     AND M11.SRC_CLASS_CODE = 'CD1072'
     AND M11.MOD_FLG = 'EAST'
     AND M11.SRC_VALUE_CODE = T1.GXH_PAY_TYPE
    --ADD IN 20240604 BEGIN 担保方逻辑加工--
    LEFT JOIN UNITE_WL_DUBIL_INFO_TMP1  T10  --联合网贷借据信息   当前数据
      ON T1.RCPT_ID = T10.DUBIL_ID
     AND T10.RQ_DAY = 'DT'
    LEFT JOIN UNITE_WL_DUBIL_INFO_TMP1  T11  --联合网贷借据信息   上年末已结清的借据
      ON T1.RCPT_ID = T11.DUBIL_ID
     AND T11.RQ_DAY = 'NC'
    LEFT JOIN GUARTOR_NAME_TMP3 T12
      ON T12.LOAN_CONT_ID = NVL(T10.CONT_ID,T11.CONT_ID)
      -- ADD IN 20240604 END 担保方逻辑加工 --
   WHERE T1.DATA_DT = V_P_DATE
     AND T1.DATA_SRC IN ('零售贷款','联合网贷')
     AND (NVL(T1.LOAN_BAL,0) <> 0 
          OR ( NVL(T1.LOAN_BAL,0) = 0 AND SUBSTR(T2.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4) ) 
          OR ( T1.DATA_SRC IN ('联合网贷') AND T2.LOAN_ACT_DSTR_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1,'YYYYMMDD') 
          ))
   ;
   COMMIT;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   -- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,XDJJH,COUNT(1)
      FROM RRP_MDL.A_PHB_ACCT_LOAN T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,XDJJH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  --插入过程跑批完成记录表
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
     V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
     ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_PHB_ACCT_LOAN;
/

