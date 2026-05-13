CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_AGCY_CONSI_DTL(I_P_DATE IN INTEGER,
                                                      O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_AGCY_CONSI_DTL
  *  功能描述：代理代销业务明细表-手工报表专用
  *  创建日期：20230224
  *  开发人员：CYK
  *  来源表：RRP_MDL.O_ICL_CMM_AGENT_CONSMT_TRAN_DTL   代理代销交易明细
             RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO  代理代销产品信息
             RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE    信托系统、代销基金系统参数码值映射表
             RRP_MDL.O_ICL_CMM_AGENT_CONSMT_LOT_INFO   代理代销份额信息
             RRP_MDL.O_IML_EVT_INSURE_TRAN_FLOW        保险交易流水
             RRP_MDL.O_IML_AGT_INSURE_PL               保险单
  *  目标表：RRP_MDL.M_MRPT_ONL_BANK_TRAN_DTL  网上银行转账与交易明细表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230224  CYK      首次创建
  *             2    20250718  LAL      为方便SG025剔除金谷产品增加TA代码字段
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_MRPT_AGCY_CONSI_DTL'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  D_STARTTIME   DATE;
  V_SQL         VARCHAR2(2000); -- 动态sql
  V_PART_NAME   VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME    VARCHAR2(100);  --表名称
  D_DATE        DATE;           --数据日期（date类型）
  D_ENDTIME     DATE;
  D_LQDATE      DATE;        --数据日期(数值型)YYYYMMDD  上一季度末

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  D_DATE   :=TO_DATE(V_P_DATE,'YYYYMMDD');
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_AGCY_CONSI_DTL'; --表名称
    --因为存在退保的情况，季度跑批可能要延后几天才能正确，固定D_LQDATE如果不是本季度末则跑上季度的数据。
  D_LQDATE := CASE WHEN TRUNC(D_DATE+1,'Q')-1 = D_DATE THEN D_DATE  ELSE TRUNC(D_DATE,'Q')-1 END;

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入信托资管明细数据';
  D_STARTTIME := SYSDATE;

  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_MRPT_AGCY_CONSI_DTL NOLOGGING
   (
      DATA_DT         -- 01   数据日期
     ,SOURCE_TYPE     -- 02   数据类别  --保险、基金、信托资管
     ,PROD_ID         -- 03   产品编号
     ,PROD_ATTR_CD    -- 04   产品属性代码
     ,TRAN_CD         -- 05   交易代码
     ,HX_PRDTYPE      -- 06  代销类型
     ,HX_TYPEDETAIL   -- 07  代销细分类型
     ,CFM_AMT         -- 08  确认金额
     ,TRAN_STATUS_CD  -- 09  交易状态代码
     ,FLOW_NUM        -- 10  流水号
     ,BUS_CD          -- 11  业务代码
     ,TRAN_ORG_ID     -- 12  交易机构编号
     ,PROD_NAME       -- 13  产品名称
     ,CFM_DT          -- 14   确认日期
     ,RISK_LEVEL_CD   -- 15   风险等级代码
     ,NV              -- 16   净值
     ,TOT_LOT         -- 17   总份额
     ,END_DT          -- 18   产品到期日
     ,TA_CD           -- 19   TA代码  为方便SG025剔除金谷产品增加TA代码字段  MODIFY BY LAL 20250718
   )
 SELECT /*+PARALLEL*/
       V_P_DATE         -- 01   数据日期
      ,'信托资管'        --02   数据类别
      ,T1.PROD_ID       -- 03   产品编号
      ,T2.PROD_ATTR_CD  -- 04   产品属性代码
      ,T1.TRAN_CD       -- 05   交易代码
      ,DECODE(T3.FIELD_VALUE,'1','信托TA','2','资管TA',T3.FIELD_VALUE)  -- 06   代销类型
      /*DECODE(T4.FIELD_VALUE,'1','货币型','2','债券型','3','股票型','4','FOF型','5','非标类','6','混合类',T4.FIELD_VALUE)*/
      --代销产品类型如果是资管类的，代销细分类型都选债券型,现在监管报送字段有新的要修改，我们还没投产，所以要等投产完再同步存量的数据--詹俊辉 20220307
      ,DECODE(T3.FIELD_VALUE,'2','债券型')   -- 07   代销细分类型
      ,T1.CFM_AMT       -- 08   确认金额
      ,T1.TRAN_STATUS_CD-- 09   交易状态代码
      ,T1.TA_CFM_FLOW_NUM  -- 10   流水号
      ,T1.BUS_CD        -- 11   业务代码
      ,T1.TRAN_ORG_ID   -- 12   交易机构编号
      ,T2.PROD_NAME     -- 13   产品名称
      ,T1.TA_CFM_DT     -- 14   确认日期
      ,T2.RISK_LEVEL_CD --15   风险等级代码
      ,T5.NV            --16   净值
      ,T5.TOT_LOT       --17   总份额  取T5的净值和总份额比较接近
      ,T2.END_DT        --18   产品到期日
      ,T1.TA_CD         --19   TA代码  为方便SG025剔除金谷产品增加TA代码字段  MODIFY BY LAL 20250718
 FROM (SELECT T.*
         FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_TRAN_DTL T
        WHERE T.CONSMT_BUS_TYPE_CD = '04'
          AND T.ETL_DT <= D_DATE ) T1
 JOIN (SELECT T.*
         FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO  T
        WHERE T.CONSMT_BUS_TYPE_CD='04'
          AND T.ETL_DT = D_DATE ) T2
   ON T1.PROD_ID = T2.PROD_ID
 LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE T3
   ON T1.PROD_ID = T3.PRD_CODE
  AND T3.START_DT <= D_DATE
  AND T3.END_DT > D_DATE
  AND T3.FIELD_CODE = 'hx_prdtype'
    --代销类型：1 信托TA  2 资管TA
 LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE T4
   ON T1.PROD_ID = T4.PRD_CODE
  AND T4.START_DT <= D_DATE
  AND T4.END_DT > D_DATE
  AND T4.FIELD_CODE = 'hx_typedetail'
   --代销细分类型： 1 货币型、2 债券型、3 股票型、4 FOF型、5 非标类、6 混合类
 LEFT JOIN (SELECT PROD_ID,NV,SUM(TOT_LOT)TOT_LOT
              FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_LOT_INFO
             WHERE ETL_DT = D_DATE
               AND CONSMT_BUS_TYPE_CD = '04'
             GROUP BY PROD_ID,NV ) T5 --TCS.TBSHARE0
   ON T1.PROD_ID = T5.PROD_ID ;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  D_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入基金明细数据';
  D_STARTTIME := SYSDATE;

  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_MRPT_AGCY_CONSI_DTL NOLOGGING
  (
     DATA_DT         -- 01   数据日期
    ,SOURCE_TYPE     -- 02   数据类别  --保险、基金、信托资管
    ,PROD_ID         -- 03   产品编号
    ,PROD_ATTR_CD    -- 04   产品属性代码
    ,TRAN_CD         -- 05   交易代码
    ,CFM_AMT         -- 06  确认金额
    ,TRAN_STATUS_CD  -- 07  交易状态代码
    ,FLOW_NUM        -- 08  流水号
    ,BUS_CD          -- 09  业务代码
    ,TRAN_ORG_ID     -- 10  交易机构编号
    ,PROD_NAME       -- 11  产品名称
    ,CFM_DT          -- 12   确认日期
    ,RISK_LEVEL_CD   -- 13   风险等级代码
    ,AGENCY_FEE      -- 14   代理费
    ,END_DT          -- 15   产品到期日
    ,TA_CD           -- 16   TA代码  为方便SG025剔除金谷产品增加TA代码  MODIFY BY LAL 20250718
  )
  SELECT /*+PARALLEL*/
          V_P_DATE            -- 01   数据日期
         ,'基金'              -- 02   数据类别  --保险、基金、信托资管
         ,T1.PROD_ID          -- 03   产品编号
         ,T2.PROD_ATTR_CD     -- 04   产品属性代码
         ,T1.TRAN_CD          -- 05   交易代码
         ,T1.CFM_AMT          -- 06  确认金额
         ,T1.TRAN_STATUS_CD   -- 07  交易状态代码
         ,T1.TA_CFM_FLOW_NUM  -- 08  流水号
         ,T1.BUS_CD           -- 09  业务代码
         ,T1.TRAN_ORG_ID      -- 10  交易机构编号
         ,T2.PROD_NAME        -- 11  产品名称
         ,T1.TA_CFM_DT        -- 12   确认日期
         ,T2.RISK_LEVEL_CD    -- 13   风险等级代码
         ,T1.TRAN_AGENT_FEE   -- 14   代理费
         ,T2.END_DT           -- 15   产品到期日
         ,T1.TA_CD            -- 16   TA代码  为方便SG025剔除金谷产品增加TA代码  MODIFY BY LAL 20250718
    FROM ( SELECT T.*
             FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_TRAN_DTL T
            WHERE T.CONSMT_BUS_TYPE_CD = '03'
              AND T.ETL_DT <= D_DATE ) T1
    JOIN (SELECT T.*
            FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO  T
           WHERE T.CONSMT_BUS_TYPE_CD = '03'
             AND T.ETL_DT = D_DATE ) T2
      ON  T1.PROD_ID = T2.PROD_ID ;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  D_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 4; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入保险明细数据';
  D_STARTTIME := SYSDATE;

  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_MRPT_AGCY_CONSI_DTL NOLOGGING
  (
     DATA_DT           -- 01   数据日期
    ,SOURCE_TYPE       -- 02   数据类别  --保险、基金、信托资管
    ,PROD_ID           -- 03   产品编号
    ,PROD_ATTR_CD      -- 04   产品属性代码
    ,TRAN_CD           -- 05   交易代码
    ,CFM_AMT           -- 06  确认金额
    ,TRAN_STATUS_CD    -- 07  交易状态代码
    ,FLOW_NUM          -- 08  流水号
    ,TRAN_ORG_ID       -- 09  交易机构编号
    ,PROD_NAME         -- 10  产品名称
    ,CFM_DT            -- 11   确认日期
    ,RISK_LEVEL_CD     -- 12   风险等级代码
    ,END_DT            -- 13   产品到期日
    ,CTRL_FLG_INFO     -- 14   控制标志信息
    ,INSURE_PROD_PROJ_TYPE_CD  --15 产品子类型
    ,COMM_FEE                  --16 手续费
    ,TRAN_CHN_CD               --17 交易渠道
  )
  SELECT /*+PARALLEL*/
          V_P_DATE             -- 01  数据日期
         ,'保险'               -- 02  数据类别  --保险、基金、信托资管
         ,T1.PROD_ID           -- 03  产品编号
         ,T2.PROD_ATTR_CD      -- 04  产品属性代码
         ,T1.TRAN_CD           -- 05  交易代码
         ,T1.TRAN_AMT          -- 06  确认金额
         ,CASE WHEN T3.TRAN_STATUS_CD='1' AND T1.TRAN_STATUS_CD='3' THEN '0' ELSE  T3.TRAN_STATUS_CD END  TRAN_STATUS_CD  --07交易状态代码  CD2173  modify by cyk 20220707改为保单状态 CD2173
            --保单状态 1 非犹豫期退保  交易状态 3 已退保 的数据将交易状态代码改为0，该部分需要统计
         ,T1.INSURE_PL_NUM     -- 08  流水号  modify by cyk 20220331改为保单号
         ,T1.TRAN_ORG_ID       -- 09  交易机构编号
         ,T2.PROD_NAME         -- 10  产品名称
         ,T1.POLICY_DT         -- 11  确认日期   modify by cyk 20220331改为投保日期
         ,T2.RISK_LEVEL_CD     -- 12  风险等级代码
         ,T2.END_DT            -- 13  产品到期日
         ,T2.CTRL_FLG_INFO     -- 14  控制标志信息
         ,T2.INSURE_PROD_PROJ_TYPE_CD  --15 产品子类型
         ,T1.COMM_FEE                  --16 手续费
         ,T1.TRAN_CHN_CD               --17 交易渠道
    FROM ( SELECT T.*
             FROM RRP_MDL.O_IML_EVT_INSURE_TRAN_FLOW T
            WHERE 
             -- T.POLICY_DT BETWEEN TRUNC(D_DATE,'Y') AND D_DATE
                 T.POLICY_DT BETWEEN TRUNC(D_LQDATE,'Y') AND D_DATE   --UPDATE XMY 20240109  因为存在退保的情况，季度跑批可能要延后几天才能正确，固定D_LQDATE如果不是本季度末则跑上季度的数据
             AND T.START_DT <= TO_DATE(V_P_DATE ,'YYYY-MM-DD')
             AND T.END_DT > TO_DATE(V_P_DATE ,'YYYY-MM-DD')
             AND T.TRAN_STATUS_CD IN ('S','3')    --modify by cyk 20221115 非犹豫期退保的交易状态为已退保，需要保留。S 成功  3 已退保
             AND T.TRAN_CD <> '510016' --剔除交易代码为新单重打  modify by cyk 20220913
           ) T1  --modify by cyk 20220331改为投保日期限定时间区间
    JOIN (SELECT T.*
            FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO T
           WHERE T.CONSMT_BUS_TYPE_CD='02'
             AND T.ETL_DT=D_DATE) T2
      ON  T1.PROD_ID = T2.PROD_ID
    JOIN RRP_MDL.O_IML_AGT_INSURE_PL T3
      ON T1.INSURE_PL_NUM = T3.INSURE_PL_ID
     AND T3.START_DT <= D_DATE
     AND T3.END_DT > D_DATE ;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  D_ENDTIME := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 5;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --调度依赖存储过程的状态
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    D_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_AGCY_CONSI_DTL;
/

