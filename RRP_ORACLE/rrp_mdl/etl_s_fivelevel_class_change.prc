CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_FIVELEVEL_CLASS_CHANGE (I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_FIVELEVEL_CLASS_CHANGE
  *  功能描述：五级分类变动台账
  *  创建日期：20230227
  *  开发人员：周一威
  *  来源表：   RRP_MDL.S_LOAN  -- 贷款业务整合表
                RRP_MDL.M_PUM_EXRT_INFO  -- 汇率表
                RRP_MDL.M_ASSET_PRESERVATION_LEDGET  -- 资产保全台账信息表
  *
  *  配置表：
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *    1   20230328  Liuyu    按照荣炳华口径调整逻辑
  *  明确：统计余额 需要取 借据净值，汇率需要统一取 报告日汇率
      2    20230417  LIUYU    按照业务制度 报告期减少金额 不统计 当年发放借据情况
                              当年放款减少金额（元） 不统计 往年放款借据情况
      3    20230505  liuyu    年初五级分类为空默认无
                              借据号变更默认逻辑
                              20210322360350011
                              20210322360350021
                              20210322360350031
                              20210322360350041
      4    20230525  liuyu    重组标志码值调整为 本年重组 往年重组 非重组
      5    20240628  lwb      补充联合网贷20231231的放款金额
      6    20250508  LWB      修改机构号的逻辑，优先取年初的机构数据，分两段处理
      7    20251110  lwb      修改机构号逻辑，改成抓取分行维度变动的逻辑
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(40) := 'ETL_S_FIVELEVEL_CLASS_CHANGE'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_LAST_YEAR_END VARCHAR2(8);
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_FIVELEVEL_CLASS_CHANGE'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期
  V_LAST_YEAR_END:= (SUBSTR(V_P_DATE,1,4)-1) || '1231'; --上年末

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_FIVELEVEL_CLASS_CHANGE T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'M_ASSET_PRESERVATION_LEDGET'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  /*增加表分区及重跑逻辑,在插入目标报表数据逻辑之前添加这段逻辑*/
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;
   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);  --增加分区   '1' 数据日期为'YYYYMMDD'  ， '2' 数据日期为'YYYY-MM-DD'
   EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '五级分类变动台账';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_FIVELEVEL_CLASS_CHANGE
  (
     DATA_SRC                  -- 1.数据来源
    ,RCPT_ID                   -- 2.交易唯一码
    ,DATA_DT                   -- 3.报告日期
    ,CUR                       -- 4.币种
    ,EXRT                      -- 5.汇率
    ,LOAN_AMT_CNY              -- 6.放款金额_折币（元）
    ,LOAN_AMT                  -- 7.放款金额（原币种元）
    ,BEGIN_YEAR_LVL5_CL        -- 8.年初五级分类
    ,BEGIN_YEAR_LOAN_BAL_CNY   -- 9.年初统计余额_折币（元）
    ,BEGIN_YEAR_LOAN_BAL       -- 10.年初统计余额（原币种元）
    ,LVL5_CL                   -- 11.五级分类
    ,LOAN_BAL_CNY              -- 12.统计余额_折币（元）
    ,LOAN_BAL                  -- 13.统计余额（原币种元）
    ,REDUCE_LOAN_BAL_CNY       -- 14.报告期减少金额（元）
    ,REDUCE_LOAN_BAL           -- 15.报告期减少金额（原币种元）
    ,REDUCE_LOAN_AMT_CNY       -- 16.当年放款减少金额（元）
    ,REDUCE_LOAN_AMT           -- 17.当年放款减少金额（原币种元）
    ,REC_ID                    -- 18.重组标识
    ,STD_PROD_ID               -- 19.统计业务品种
    ,ORG_ID                    -- 20.账务机构编号 -- modby liuyu 新增机构号字段
    ,BD_ORG_ID                 -- 21.变动账务机构
    ,BD_FLG                    -- 22.账务机构变动标志
  )
  SELECT A.DATA_SRC          AS DATA_SRC            -- 1.数据来源
        ,A.RCPT_ID           AS RCPT_ID             -- 2.交易唯一码
        ,V_P_DATE            AS DATA_DT             -- 3.报告日期
        ,A.CUR               AS CUR                 -- 4.币种
        ,B.EXRT              AS EXRT                -- 5.汇率
        ,A.LOAN_AMT * B.EXRT AS LOAN_AMT_CNY        -- 6.放款金额（元）
        ,A.LOAN_AMT          AS LOAN_AMT            -- 7.放款金额（原币种元）
        ,CASE WHEN C.LVL5_CL = '01' THEN '正常类'
              WHEN C.LVL5_CL = '02' THEN '关注类'
              WHEN C.LVL5_CL = '03' THEN '次级类'
              WHEN C.LVL5_CL = '04' THEN '可疑类'
              WHEN C.LVL5_CL = '05' THEN '损失类'
              WHEN A.RCPT_ID IN ('20210322360350011','20210322360350021','20210322360350031','20210322360350041') THEN '正常类'
              ELSE '无' -- mod by liuyu 根据荣炳华意见调整年初五级分类为空的默认无
         END
                             AS BEGIN_YEAR_LVL5_CL  -- 8.年初五级分类
        ,CASE WHEN A.RCPT_ID = '20210322360350011' THEN 20000000
              WHEN A.RCPT_ID = '20210322360350021' THEN 65000000
              WHEN A.RCPT_ID = '20210322360350031' THEN 137483268.78
              WHEN A.RCPT_ID = '20210322360350041' THEN 120000000
              ELSE NVL(C.LOAN_NET_VAL, 0) * B.EXRT
         END
                             AS BEGIN_YEAR_LOAN_BAL_CNY -- 9.年初统计余额（元）
        ,CASE WHEN A.RCPT_ID = '20210322360350011' THEN 20000000
              WHEN A.RCPT_ID = '20210322360350021' THEN 65000000
              WHEN A.RCPT_ID = '20210322360350031' THEN 137483268.78
              WHEN A.RCPT_ID = '20210322360350041' THEN 120000000
              ELSE NVL(C.LOAN_NET_VAL, 0)
         END
                             AS BEGIN_YEAR_LOAN_BAL -- 10.年初统计余额（原币种元）
        ,CASE WHEN A.LVL5_CL = '01' THEN '正常类'
              WHEN A.LVL5_CL = '02' THEN '关注类'
              WHEN A.LVL5_CL = '03' THEN '次级类'
              WHEN A.LVL5_CL = '04' THEN '可疑类'
              WHEN A.LVL5_CL = '05' THEN '损失类'
         END          AS LVL5_CL             -- 11.五级分类
        ,NVL(A.LOAN_NET_VAL,0 ) * B.EXRT
                             AS LOAN_BAL_CNY        -- 12.统计余额（元）
        ,NVL(A.LOAN_NET_VAL,0)
                             AS LOAN_NET_VAL        -- 13.统计余额（原币种元）
        ,CASE WHEN A.DATA_SRC='联合网贷' AND A.LOAN_ACT_DSTR_DT=V_LAST_YEAR_END THEN 0 --MODIFY BY LWB
              WHEN SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) = SUBSTR(V_P_DATE, 1, 4) THEN 0 --如果本年新发放，该部分默认0
              ELSE (NVL(C.LOAN_NET_VAL, 0) * B.EXRT) - (A.LOAN_NET_VAL * B.EXRT)
         END
                             AS REDUCE_LOAN_BAL_CNY -- 14.报告期减少金额（元）
        ,CASE WHEN SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) = SUBSTR(V_P_DATE, 1, 4) THEN 0
              ELSE NVL(C.LOAN_NET_VAL, 0) - NVL(A.LOAN_NET_VAL,0)
         END
                             AS REDUCE_LOAN_BAL     -- 15.报告期减少金额（原币种元）
        ,CASE WHEN A.DATA_SRC='联合网贷' AND A.LOAN_ACT_DSTR_DT=V_LAST_YEAR_END
                   THEN NVL(A.LOAN_AMT,0) * B.EXRT - NVL(A.LOAN_NET_VAL,0) * B.EXRT
              WHEN (SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) <> SUBSTR(V_P_DATE, 1, 4))  THEN 0
              ELSE NVL(A.LOAN_AMT,0) * B.EXRT - NVL(A.LOAN_NET_VAL,0) * B.EXRT
         END
                             AS REDUCE_LOAN_AMT_CNY -- 16.当年放款减少金额（元）modify by lwb 20240628
        ,CASE WHEN SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) <> SUBSTR(V_P_DATE, 1, 4) THEN 0
              ELSE NVL(A.LOAN_AMT,0) - NVL(A.LOAN_NET_VAL,0)
         END
                             AS REDUCE_LOAN_AMT     -- 17.当年放款减少金额（原币种元）
        ,CASE WHEN E.DUEBILLID IS NOT NULL THEN
              CASE WHEN TO_CHAR(E.HANDLETIME, 'YYYY') = SUBSTR(V_P_DATE, 1, 4) THEN '本年重组'
                   WHEN TO_CHAR(E.HANDLETIME, 'YYYY') < SUBSTR(V_P_DATE, 1, 4) THEN '往年重组'
              END
              ELSE '非重组'  --MOD BY LIUYU 20230525 按照业务制度调整码值
         END                 AS REC_ID              -- 18.重组标识
        ,A.STD_PROD_ID       AS STD_PROD_ID         -- 19.统计业务品种
        ,A.ORG_ID          AS ORG_ID              -- 20.账务机构编号 MODIFY BY LWB
        ,A.ORG_ID    AS BD_ORG_ID
        ,'N'  AS  BD_FLG
    FROM RRP_MDL.S_LOAN A -- 贷款业务整合表
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO B -- 汇率表
      ON B.CNV_CUR = 'CNY'
     AND B.BASE_CUR = A.CUR
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.S_LOAN C -- 贷款业务整合表 -- 上年末
      ON C.RCPT_ID = A.RCPT_ID
     AND C.DATA_DT = V_LAST_YEAR_END
    LEFT JOIN (SELECT DUEBILLID,MIN(HANDLETIME) AS HANDLETIME
                 FROM RRP_MDL.M_ASSET_PRESERVATION_LEDGET -- 资产保全台账信息表
                WHERE DATA_DT = V_P_DATE
                  AND HANDLETYPE IN ('债务重组', '借新还旧', '展期') -- 处置（含重组）时间
                  -- AND TO_CHAR(HANDLETIME, 'YYYY') = SUBSTR(V_P_DATE, 1, 4) -- 处置（含重组）时间
                GROUP BY DUEBILLID
               ) E
      ON E.DUEBILLID = A.RCPT_ID -- 借据号
   WHERE A.DATA_DT = V_P_DATE
     AND ((A.LOAN_NET_VAL + NVL(C.LOAN_NET_VAL, 0) <> 0)
         OR (SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) = SUBSTR(V_P_DATE, 1, 4))
         OR (A.DATA_SRC='联合网贷' AND A.LOAN_ACT_DSTR_DT=V_LAST_YEAR_END))  -- 贷款实际发放日期
     AND SUBSTR(NVL(C.ORG_ID,A.ORG_ID),0,3)=SUBSTR(A.ORG_ID,0,3)--年初账务机构未变动数据 20251110 modify by lwb
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
    -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '账务机构变动的五级分类变动台账';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_FIVELEVEL_CLASS_CHANGE
  (
     DATA_SRC                  -- 1.数据来源
    ,RCPT_ID                   -- 2.交易唯一码
    ,DATA_DT                   -- 3.报告日期
    ,CUR                       -- 4.币种
    ,EXRT                      -- 5.汇率
    ,LOAN_AMT_CNY              -- 6.放款金额_折币（元）
    ,LOAN_AMT                  -- 7.放款金额（原币种元）
    ,BEGIN_YEAR_LVL5_CL        -- 8.年初五级分类
    ,BEGIN_YEAR_LOAN_BAL_CNY   -- 9.年初统计余额_折币（元）
    ,BEGIN_YEAR_LOAN_BAL       -- 10.年初统计余额（原币种元）
    ,LVL5_CL                   -- 11.五级分类
    ,LOAN_BAL_CNY              -- 12.统计余额_折币（元）
    ,LOAN_BAL                  -- 13.统计余额（原币种元）
    ,REDUCE_LOAN_BAL_CNY       -- 14.报告期减少金额（元）
    ,REDUCE_LOAN_BAL           -- 15.报告期减少金额（原币种元）
    ,REDUCE_LOAN_AMT_CNY       -- 16.当年放款减少金额（元）
    ,REDUCE_LOAN_AMT           -- 17.当年放款减少金额（原币种元）
    ,REC_ID                    -- 18.重组标识
    ,STD_PROD_ID               -- 19.统计业务品种
    ,ORG_ID                    -- 20.账务机构编号 -- modby liuyu 新增机构号字段
    ,BD_ORG_ID                 -- 21.变动账务机构
    ,BD_FLG                    -- 22.账务机构变动标志
  )
  SELECT A.DATA_SRC          AS DATA_SRC            -- 1.数据来源
        ,A.RCPT_ID           AS RCPT_ID             -- 2.交易唯一码
        ,V_P_DATE            AS DATA_DT             -- 3.报告日期
        ,A.CUR               AS CUR                 -- 4.币种
        ,B.EXRT              AS EXRT                -- 5.汇率
        ,A.LOAN_AMT * B.EXRT AS LOAN_AMT_CNY        -- 6.放款金额（元）
        ,A.LOAN_AMT          AS LOAN_AMT            -- 7.放款金额（原币种元）
        ,CASE WHEN C.LVL5_CL = '01' THEN '正常类'
              WHEN C.LVL5_CL = '02' THEN '关注类'
              WHEN C.LVL5_CL = '03' THEN '次级类'
              WHEN C.LVL5_CL = '04' THEN '可疑类'
              WHEN C.LVL5_CL = '05' THEN '损失类'
              WHEN A.RCPT_ID IN ('20210322360350011','20210322360350021','20210322360350031','20210322360350041') THEN '正常类'
              ELSE '无' -- mod by liuyu 根据荣炳华意见调整年初五级分类为空的默认无
         END
                             AS BEGIN_YEAR_LVL5_CL  -- 8.年初五级分类
        ,CASE WHEN A.RCPT_ID = '20210322360350011' THEN 20000000
              WHEN A.RCPT_ID = '20210322360350021' THEN 65000000
              WHEN A.RCPT_ID = '20210322360350031' THEN 137483268.78
              WHEN A.RCPT_ID = '20210322360350041' THEN 120000000
              ELSE NVL(C.LOAN_NET_VAL, 0) * B.EXRT
         END
                             AS BEGIN_YEAR_LOAN_BAL_CNY -- 9.年初统计余额（元）
        ,CASE WHEN A.RCPT_ID = '20210322360350011' THEN 20000000
              WHEN A.RCPT_ID = '20210322360350021' THEN 65000000
              WHEN A.RCPT_ID = '20210322360350031' THEN 137483268.78
              WHEN A.RCPT_ID = '20210322360350041' THEN 120000000
              ELSE NVL(C.LOAN_NET_VAL, 0)
         END
                             AS BEGIN_YEAR_LOAN_BAL -- 10.年初统计余额（原币种元）
        ,CASE WHEN A.LVL5_CL = '01' THEN '正常类'
              WHEN A.LVL5_CL = '02' THEN '关注类'
              WHEN A.LVL5_CL = '03' THEN '次级类'
              WHEN A.LVL5_CL = '04' THEN '可疑类'
              WHEN A.LVL5_CL = '05' THEN '损失类'
         END          AS LVL5_CL             -- 11.五级分类
        ,NVL(A.LOAN_NET_VAL,0 ) * B.EXRT
                             AS LOAN_BAL_CNY        -- 12.统计余额（元）
        ,NVL(A.LOAN_NET_VAL,0)
                             AS LOAN_NET_VAL        -- 13.统计余额（原币种元）
        ,CASE WHEN A.DATA_SRC='联合网贷' AND A.LOAN_ACT_DSTR_DT=V_LAST_YEAR_END THEN 0 --MODIFY BY LWB
              WHEN SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) = SUBSTR(V_P_DATE, 1, 4) THEN 0 --如果本年新发放，该部分默认0
              ELSE NVL(C.LOAN_NET_VAL, 0) * B.EXRT --20250520变动修改
         END
                             AS REDUCE_LOAN_BAL_CNY -- 14.报告期减少金额（元）  针对转出机构，报告期减少金额默认为年初余额 LWB 20250520
        ,CASE WHEN SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) = SUBSTR(V_P_DATE, 1, 4) THEN 0
              ELSE NVL(C.LOAN_NET_VAL, 0) - NVL(A.LOAN_NET_VAL,0)
         END
                             AS REDUCE_LOAN_BAL     -- 15.报告期减少金额（原币种元）
        ,CASE WHEN A.DATA_SRC='联合网贷' AND A.LOAN_ACT_DSTR_DT=V_LAST_YEAR_END
                   THEN NVL(A.LOAN_AMT,0) * B.EXRT - NVL(A.LOAN_NET_VAL,0) * B.EXRT
              WHEN (SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) <> SUBSTR(V_P_DATE, 1, 4))  THEN 0
              ELSE NVL(A.LOAN_AMT,0) * B.EXRT - NVL(A.LOAN_NET_VAL,0) * B.EXRT
         END
                             AS REDUCE_LOAN_AMT_CNY -- 16.当年放款减少金额（元）modify by lwb 20240628
        ,CASE WHEN SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) <> SUBSTR(V_P_DATE, 1, 4) THEN 0
              ELSE NVL(A.LOAN_AMT,0) - NVL(A.LOAN_NET_VAL,0)
         END
                             AS REDUCE_LOAN_AMT     -- 17.当年放款减少金额（原币种元）
        ,CASE WHEN E.DUEBILLID IS NOT NULL THEN
              CASE WHEN TO_CHAR(E.HANDLETIME, 'YYYY') = SUBSTR(V_P_DATE, 1, 4) THEN '本年重组'
                   WHEN TO_CHAR(E.HANDLETIME, 'YYYY') < SUBSTR(V_P_DATE, 1, 4) THEN '往年重组'
              END
              ELSE '非重组'  --MOD BY LIUYU 20230525 按照业务制度调整码值
         END                 AS REC_ID              -- 18.重组标识
        ,A.STD_PROD_ID       AS STD_PROD_ID         -- 19.统计业务品种
        ,NVL(C.ORG_ID,A.ORG_ID)           AS ORG_ID              -- 20.账务机构编号 MODIFY BY LWB 转出机构号
        ,A.ORG_ID   as BD_ORG_ID  --账务机构编号 MODIFY BY LWB 转入机构号
        ,'Y'        AS BD_FLG    --账务机构变动标志
    FROM RRP_MDL.S_LOAN A -- 贷款业务整合表
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO B -- 汇率表
      ON B.CNV_CUR = 'CNY'
     AND B.BASE_CUR = A.CUR
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.S_LOAN C -- 贷款业务整合表 -- 上年末
      ON C.RCPT_ID = A.RCPT_ID
     AND C.DATA_DT = V_LAST_YEAR_END
    LEFT JOIN (SELECT DUEBILLID,MIN(HANDLETIME) AS HANDLETIME
                 FROM RRP_MDL.M_ASSET_PRESERVATION_LEDGET -- 资产保全台账信息表
                WHERE DATA_DT = V_P_DATE
                  AND HANDLETYPE IN ('债务重组', '借新还旧', '展期') -- 处置（含重组）时间
                  -- AND TO_CHAR(HANDLETIME, 'YYYY') = SUBSTR(V_P_DATE, 1, 4) -- 处置（含重组）时间
                GROUP BY DUEBILLID
               ) E
      ON E.DUEBILLID = A.RCPT_ID -- 借据号
   WHERE A.DATA_DT = V_P_DATE
     AND ((A.LOAN_NET_VAL + NVL(C.LOAN_NET_VAL, 0) <> 0)
         OR (SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) = SUBSTR(V_P_DATE, 1, 4))
         OR (A.DATA_SRC='联合网贷' AND A.LOAN_ACT_DSTR_DT=V_LAST_YEAR_END))
     AND SUBSTR(NVL(C.ORG_ID,A.ORG_ID),0,3)<>SUBSTR(A.ORG_ID,0,3)--年初账务机构未变动数据 20251110 modify by lwb MOD BY 20251121
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


    -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_FIVELEVEL_CLASS_CHANGE;
/

