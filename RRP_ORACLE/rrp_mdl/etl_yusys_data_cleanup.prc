CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_YUSYS_DATA_CLEANUP
  (I_DATADATE   IN INTEGER,  --跑批日期
   I_TAB_GROUP  IN VARCHAR2, --分组
   O_ERRCODE    OUT VARCHAR2     --错误代码
  )
/***********************************************************************
  ************************************************************************
    **  存储过程详细说明：根据ETL_DATA_CLEANUP_CONF表配置的清数策略清理数据
    **  存储过程名称:  ETL_DATA_CLEANUP
    **  存储过程创建日期:2024-04-09
    **  存储过程创建人:谢子扬
    **  调用示例:
         DECLARE
           I_DATADATE INTEGER;
           O_ERRCODE  CHAR(1);
         BEGIN
           I_DATADATE := '20220101';
           ETL_YUSYS_DATA_CLEANUP(I_DATADATE,1,O_ERRCODE);
         END;
    **  输入参数:   I_DATADATE(跑批日期),I_TAB_GROUP(跑批组别)
    **  输出参数:   O_ERRCODE
    **  返回值:     0正确 1错误
    **  修改日期          修改项目        修改原因           修改人
    **
    ************************************************************************
  ***********************************************************************/
 IS
  D_DATE       DATE;            --跑批日期（日期类型）
  E_EXPT       EXCEPTION;       --自定义异常
  I_PCN        INTEGER;         --校验分区
  V_DATEID     CHAR(8);         --跑批日期（字符类型）
  V_EXE_ERR    VARCHAR2(1000);  --错误信息
  V_PRT_NM     VARCHAR2(100);   --表分区名称
  V_SQL        VARCHAR2(2000);  --自定义SQL
  
  --日志相关变量
  D_ENDTIME    DATE;            -- 处理结束时间
  D_STARTTIME  DATE;            -- 处理开始时间
  I_SQLCOUNT   INTEGER := 0;    -- 更新或删除影响的记录数
  I_STEP       INTEGER := 0;    -- 处理步骤
  I_STEP_DESC  VARCHAR2(100);   -- 处理步骤描述
  V_PROC_NAME  VARCHAR2(100);   -- 程序名称
  V_SQLMSG     VARCHAR2(300);   -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);    -- 来源系统

BEGIN
  D_DATE       := TO_DATE(I_DATADATE,'YYYYMMDD'); --转化日期类型DATE
  O_ERRCODE    := '0';
  V_DATEID     := TO_CHAR(I_DATADATE);            --转化日期类型VARCHAR
  V_PROC_NAME  := 'ETL_YUSYS_DATA_CLEANUP';

  -- 日志 --
  D_STARTTIME := SYSDATE;
  I_STEP      := 1;
  I_STEP_DESC := '分组为'''||I_TAB_GROUP||'''的表数据清理开始';
  V_SYSTEM    := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  D_ENDTIME   := SYSDATE;
  IF I_TAB_GROUP IS NULL THEN RAISE E_EXPT; END IF;--检查分组参数
    
  ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,0,O_ERRCODE,'');

  --生成执行delete语句，逐个表删除数据
    --获取配置表信息（ETL_DATA_CLEANUP_CONF）
  FOR DEL_INFO IN
   (SELECT 'DELETE FROM '||SCH_NAME||'.'||A.TABLE_NAME||' WHERE '||
           CASE WHEN COL_TYPE = 'VARCHAR2' THEN ' TO_DATE('||COL_NAME||','''||COL_FORMAT||''')=DATE'''||TO_CHAR(TO_DATE(V_DATEID,'YYYYMMDD')-NVL(KEEP_NUM,0),'YYYY-MM-DD')||''''
                WHEN COL_TYPE = 'DATE' THEN COL_NAME||'=DATE'''||TO_CHAR(TO_DATE(V_DATEID,'YYYYMMDD')-NVL(KEEP_NUM,0),'YYYY-MM-DD')||''''
            END AS EXEC_SQL,
           CASE WHEN COL_TYPE = 'VARCHAR2' THEN --VARCHAR2类型的数据清理
                  CASE KEEP_TYPE
                    WHEN 'W' THEN ' AND TO_CHAR(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''), ''D'') <> ''1''' --保留周末
                    WHEN 'X' THEN ' AND NOT (TO_CHAR(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''), ''DD'') IN (10, 20) '||
                                  'OR TO_DATE('||COL_NAME||','''||COL_FORMAT||''') = LAST_DAY(TO_DATE('||COL_NAME||','''||COL_FORMAT||''')))'--保留旬末
                    WHEN 'M' THEN ' AND TO_DATE('||COL_NAME||','''||COL_FORMAT||''')<>LAST_DAY(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''))'--保留月末
                    WHEN 'Q' THEN ' AND NOT (EXTRACT(MONTH FROM TO_DATE('||COL_NAME||','''||COL_FORMAT||''')) IN (3, 6, 9, 12) '||
                                  'AND TO_CHAR(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''), ''DD'') = TO_CHAR(LAST_DAY(TO_DATE('||COL_NAME||','''||COL_FORMAT||''')), ''DD''))'--保留季末
                    WHEN 'HY' THEN ' AND NOT (EXTRACT(MONTH FROM TO_DATE('||COL_NAME||','''||COL_FORMAT||''')) IN (6,12) '||
                                  'AND TO_CHAR(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''), ''DD'') = TO_CHAR(LAST_DAY(TO_DATE('||COL_NAME||','''||COL_FORMAT||''')), ''DD''))'--保留半年末
                    WHEN 'Y' THEN ' AND NOT (EXTRACT(MONTH FROM TO_DATE('||COL_NAME||','''||COL_FORMAT||''')) = 12 '||
                                  'AND TO_CHAR(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''), ''DD'') = ''31'')' --保留年末
                    WHEN 'N' THEN '' --无保留
                    ELSE '1' --未设置清理策略
                   END
                WHEN COL_TYPE = 'DATE' THEN   --DATE类型的数据清理
                  CASE KEEP_TYPE
                    WHEN 'W' THEN ' AND TO_CHAR('||COL_NAME||', ''D'') <> ''1'')' --保留周末
                    WHEN 'X' THEN ' AND NOT (TO_CHAR('||COL_NAME||', ''DD'') IN (10, 20) '||
                                  'OR '||COL_NAME||' = TO_CHAR(LAST_DAY('||COL_NAME||'), ''DD''))'--保留旬末
                    WHEN 'M' THEN ' AND '||COL_NAME||'<>LAST_DAY('||COL_NAME||')'--保留月末
                    WHEN 'Q' THEN ' AND NOT (EXTRACT(MONTH FROM '||COL_NAME||') IN (3,6,9,12) '||
                                  'AND TO_CHAR('||COL_NAME||', ''DD'') = TO_CHAR(LAST_DAY('||COL_NAME||'), ''DD''))'--保留季末
                    WHEN 'HY' THEN ' AND NOT (EXTRACT(MONTH FROM '||COL_NAME||') IN (6,12) '||
                                  'AND TO_CHAR('||COL_NAME||', ''DD'') = TO_CHAR(LAST_DAY('||COL_NAME||'), ''DD''))'--保留半年末
                    WHEN 'Y' THEN ' AND NOT (EXTRACT(MONTH FROM '||COL_NAME||') = 12 '||
                                  'AND TO_CHAR('||COL_NAME||', ''DD'') = ''31'')' --保留年末
                    WHEN 'N' THEN '' --无保留
                    ELSE '1'         --未设置保留类型
                   END
            END AS KEEP_SQL,
           A.SCH_NAME,   --模式
           A.TABLE_NAME, --表名
           DECODE(KEEP_NUM,NULL,'1',0,'2','0') AS IS_KEEP,  --判断保留天数是否为空
           DECODE(B.TABLE_NAME,NULL,'1','0') AS IS_EXISTS   --判断表是否存在
      FROM ETL_DATA_CLEANUP_CONF A  --配置表
      LEFT JOIN ALL_TABLES B        --关联字典表
             ON A.SCH_NAME = B.OWNER
            AND A.TABLE_NAME = B.TABLE_NAME
     WHERE V_DATEID BETWEEN BEGIN_DT AND END_DT  --配置表为拉链表，不直接修改，保留历史
       AND CLE_TYPE = 'D'     --清理策略为DELETE
       AND TAB_GROUP = NVL(I_TAB_GROUP,1)
   ) LOOP
    BEGIN
      --日志
      I_STEP      := I_STEP+1;
      D_STARTTIME := SYSDATE;
      I_STEP_DESC := '清理表'||DEL_INFO.SCH_NAME||'.'||DEL_INFO.TABLE_NAME||'''数据';
    
      --判断配置是否合法，非合法更新EXEC_STATUS字段
      V_EXE_ERR :=V_DATEID||':';
      IF DEL_INFO.IS_KEEP   ='1' THEN V_EXE_ERR:=V_EXE_ERR||'保留天数为空 '; END IF;
      IF DEL_INFO.IS_KEEP   ='2' THEN V_EXE_ERR:=V_EXE_ERR||'保留天数为0 '; END IF;
      IF DEL_INFO.KEEP_SQL  ='1' THEN V_EXE_ERR:=V_EXE_ERR||'保留类型错误:N无,W周末,X旬末,M月末,Q季末,HY半年,Y年 '; END IF;
      IF DEL_INFO.IS_EXISTS ='1' THEN V_EXE_ERR:=V_EXE_ERR||'表'||DEL_INFO.SCH_NAME||'.'||DEL_INFO.TABLE_NAME||'不存在 '; END IF;

      if DEL_INFO.IS_KEEP in ('1','2') or DEL_INFO.KEEP_SQL='1' or DEL_INFO.IS_EXISTS='1' then
         UPDATE ETL_DATA_CLEANUP_CONF SET EXEC_STATUS = V_EXE_ERR
          WHERE SCH_NAME = DEL_INFO.SCH_NAME
            AND TABLE_NAME = DEL_INFO.TABLE_NAME;
         COMMIT;
         --日志
         D_ENDTIME   := SYSDATE;
         ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_EXE_ERR);

      else --无配置错误则执行程序
         EXECUTE IMMEDIATE (DEL_INFO.EXEC_SQL||DEL_INFO.KEEP_SQL);--清理数据
         I_SQLCOUNT := SQL%ROWCOUNT; --删除记录数
         COMMIT;
         D_ENDTIME   := SYSDATE;
         ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
         
         UPDATE ETL_DATA_CLEANUP_CONF 
            SET EXEC_STATUS = V_DATEID||':清理记录'||I_SQLCOUNT||',sql:'||DEL_INFO.EXEC_SQL||DEL_INFO.KEEP_SQL --更新状态，保留脚本
          WHERE SCH_NAME = DEL_INFO.SCH_NAME
            AND TABLE_NAME = DEL_INFO.TABLE_NAME;
         COMMIT;
         --DBMS_OUTPUT.PUT_LINE('EXECUTE: ' || DEL_INFO.EXEC_SQL||DEL_INFO.KEEP_SQL);
      end if;

      EXCEPTION
        WHEN OTHERS THEN
          V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
          D_ENDTIME   := SYSDATE;
          O_ERRCODE   := '1';
          ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
         
          UPDATE ETL_DATA_CLEANUP_CONF A SET EXEC_STATUS = V_SQLMSG
           WHERE A.SCH_NAME = DEL_INFO.SCH_NAME
             AND A.TABLE_NAME = DEL_INFO.TABLE_NAME;
          COMMIT;
      END;
  END LOOP;

  --生成执行清分区或删分区的语句，逐个表删除数据
    --获取配置表信息（ETL_DATA_CLEANUP_CONF）
  FOR PRT_INFO IN
   (SELECT A.SCH_NAME, A.TABLE_NAME,A.CLE_TYPE, A.KEEP_NUM, A.KEEP_TYPE, A.COL_FORMAT,
           CASE A.KEEP_TYPE
                WHEN 'W' THEN CASE WHEN TO_CHAR(D_DATE-A.KEEP_NUM ,'D')='1'
                                   THEN '9' ELSE TO_CHAR(D_DATE-A.KEEP_NUM,'YYYYMMDD') END --保留周末
                WHEN 'X' THEN CASE WHEN TO_CHAR(D_DATE-A.KEEP_NUM,'DD') IN (10,20)
                                        OR D_DATE-A.KEEP_NUM=LAST_DAY(D_DATE-A.KEEP_NUM)
                                   THEN '9' ELSE TO_CHAR(D_DATE-A.KEEP_NUM,'YYYYMMDD') END --保留旬末
                WHEN 'M' THEN CASE WHEN D_DATE-A.KEEP_NUM=LAST_DAY(D_DATE-A.KEEP_NUM)
                                   THEN '9' ELSE TO_CHAR(D_DATE-A.KEEP_NUM,'YYYYMMDD') END --保留月末
                WHEN 'Q' THEN CASE WHEN EXTRACT(MONTH FROM D_DATE-A.KEEP_NUM) IN (3, 6, 9, 12)
                                        AND D_DATE-A.KEEP_NUM=LAST_DAY(D_DATE-A.KEEP_NUM)
                                   THEN '9' ELSE TO_CHAR(D_DATE-A.KEEP_NUM,'YYYYMMDD') END --保留季末
                WHEN 'HY' THEN CASE WHEN EXTRACT(MONTH FROM D_DATE-A.KEEP_NUM) IN (6,12)
                                        AND D_DATE-A.KEEP_NUM=LAST_DAY(D_DATE-A.KEEP_NUM)
                                   THEN '9' ELSE TO_CHAR(D_DATE-A.KEEP_NUM,'YYYYMMDD') END --保留半年末
                WHEN 'Y' THEN CASE WHEN TO_CHAR(D_DATE-A.KEEP_NUM,'MMDD') = '1231'
                                   THEN '9' ELSE TO_CHAR(D_DATE-A.KEEP_NUM,'YYYYMMDD') END --保留年末
                WHEN 'N' THEN TO_CHAR(D_DATE-A.KEEP_NUM,'YYYYMMDD') --无保留
                ELSE '1'         --未设置保留类型
            END AS CLEAR_PRT,
           DECODE(KEEP_NUM,NULL,'1',0,'2','0') AS IS_KEEP,   --判断保留天数是否为空
           DECODE(B.TABLE_NAME,NULL,'1','0') AS IS_EXISTS   --判断表是否存在
      FROM ETL_DATA_CLEANUP_CONF A  --配置表
      LEFT JOIN ALL_TABLES B        --关联字典表判断表是否存在
             ON A.SCH_NAME = B.OWNER
            AND A.TABLE_NAME = B.TABLE_NAME
     WHERE V_DATEID BETWEEN BEGIN_DT AND END_DT  --配置表为拉链表，不直接修改，保留历史
       AND CLE_TYPE IN ('DP','CP')    --清理策略为DELETE
       AND TAB_GROUP = I_TAB_GROUP
   ) LOOP
    BEGIN
      --日志
      I_STEP      := I_STEP+1;
      D_STARTTIME := SYSDATE;
      I_STEP_DESC := '清理表'||PRT_INFO.SCH_NAME||'.'||PRT_INFO.TABLE_NAME||'''数据';
    
      --判断配置是否合法，非合法更新
      V_EXE_ERR :=V_DATEID||':';
      IF PRT_INFO.IS_KEEP   ='1' THEN V_EXE_ERR:=V_EXE_ERR||'保留天数为空 '; END IF;
      IF PRT_INFO.IS_KEEP   ='2' THEN V_EXE_ERR:=V_EXE_ERR||'保留天数为0 '; END IF;
      IF PRT_INFO.IS_EXISTS ='1' THEN V_EXE_ERR:=V_EXE_ERR||'表'||PRT_INFO.TABLE_NAME||'不存在 '; END IF;
      IF PRT_INFO.CLEAR_PRT ='1' THEN V_EXE_ERR:=V_EXE_ERR||'保留类型错误:N无,W周末,X旬末,M月末,Q季末,HY半年,Y年 '; END IF;

      IF PRT_INFO.IS_KEEP IN ('1','2') OR PRT_INFO.IS_EXISTS='1' OR PRT_INFO.CLEAR_PRT='1' THEN
         --日志
         D_ENDTIME   := SYSDATE;
         ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_EXE_ERR);
      
         UPDATE ETL_DATA_CLEANUP_CONF SET EXEC_STATUS = V_EXE_ERR
          WHERE SCH_NAME = PRT_INFO.SCH_NAME
            AND TABLE_NAME = PRT_INFO.TABLE_NAME;
         COMMIT;
         --DBMS_OUTPUT.PUT_LINE(V_EXE_ERR);
      ELSIF PRT_INFO.CLEAR_PRT <>'9' THEN
         V_PRT_NM:= REPLACE(PRT_INFO.COL_FORMAT,'YYYYMMDD',PRT_INFO.CLEAR_PRT);--拼接分区名

         SELECT COUNT(1) INTO I_PCN FROM ALL_TAB_PARTITIONS --查找分区是否存在
          WHERE TABLE_OWNER = PRT_INFO.SCH_NAME
            AND TABLE_NAME  = PRT_INFO.TABLE_NAME
            AND PARTITION_NAME = V_PRT_NM;

         IF I_PCN = 0 THEN --判断：分区不存在
            V_EXE_ERR:=V_EXE_ERR||'表分区'||V_PRT_NM||'不存在 '; 
            --日志
            D_ENDTIME   := SYSDATE;
            ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_EXE_ERR);

            UPDATE ETL_DATA_CLEANUP_CONF SET EXEC_STATUS = V_EXE_ERR
            WHERE SCH_NAME = PRT_INFO.SCH_NAME
              AND TABLE_NAME = PRT_INFO.TABLE_NAME;
            COMMIT;
         ELSE              --判断：分区存在
           V_SQL:='ALTER TABLE '||PRT_INFO.SCH_NAME||'.'||PRT_INFO.TABLE_NAME|| --拼接清理分区脚本
                  CASE WHEN PRT_INFO.CLE_TYPE = 'CP' THEN ' TRUNCATE '
                       WHEN PRT_INFO.CLE_TYPE = 'DP' THEN ' DROP ' END ||
                  'PARTITION '||V_PRT_NM;
           EXECUTE IMMEDIATE (V_SQL);--清理数据
           --DBMS_OUTPUT.PUT_LINE(V_SQL);
           UPDATE ETL_DATA_CLEANUP_CONF SET EXEC_STATUS = V_DATEID||':'||V_SQL --更新状态与脚本
            WHERE SCH_NAME = PRT_INFO.SCH_NAME
              AND TABLE_NAME = PRT_INFO.TABLE_NAME;
           COMMIT;
           --日志
           D_ENDTIME   := SYSDATE;
           ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_DATEID||':'||V_SQL);
      
         END IF;
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
          V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
          D_ENDTIME   := SYSDATE;
          O_ERRCODE   := '1';
          ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
         
          UPDATE ETL_DATA_CLEANUP_CONF A SET EXEC_STATUS = V_SQLMSG
           WHERE A.SCH_NAME = PRT_INFO.SCH_NAME
             AND A.TABLE_NAME = PRT_INFO.TABLE_NAME;
          COMMIT;
      END;

    END LOOP;

  --未配置清数类型的数据
  UPDATE ETL_DATA_CLEANUP_CONF SET EXEC_STATUS = V_DATEID||':清数类型配置不正确，请检查。清数方式:CP清空分区,DP删除分区,D删除数据'
  WHERE CLE_TYPE NOT IN ('D','CP','DP');
  COMMIT;

  I_STEP      := I_STEP+1;
  D_STARTTIME := SYSDATE;
  I_SQLCOUNT:=0;
  I_STEP_DESC:='分组为'''||I_TAB_GROUP||'''的表数据清理结束';
  D_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN E_EXPT THEN
    O_ERRCODE   := '1'; --将SQL错误编号赋植给O_ERRCODE
    I_STEP_DESC := '输入分组参数有误';
    D_ENDTIME  := SYSDATE;
    --DBMS_OUTPUT.PUT_LINE(I_STEP_DESC)
    ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  WHEN OTHERS THEN
    O_ERRCODE   := '1'; --将SQL错误编号赋植给O_ERRCODE
    I_STEP_DESC := '发生异常！详细信息为： ' || SUBSTR(SQLERRM, 1, 280);
    D_ENDTIME  := SYSDATE;
    --DBMS_OUTPUT.PUT_LINE(I_STEP_DESC)
    ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
END ETL_YUSYS_DATA_CLEANUP;
/

