CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_YUSYS_TEST
  (I_DATADATE   IN INTEGER,  --跑批日期
   I_TAB_GROUP  IN VARCHAR2 DEFAULT '1', --分组
   O_ERRCODE    OUT CHAR     --错误代码
  )

 IS
  D_DATE      DATE;                --跑批日期（日期类型）
  V_DATEID    CHAR(8);             --跑批日期（字符类型）
  V_EXE_ERR   VARCHAR2(1000);      --报错信息
  V_SQLMSG    VARCHAR2(300);       --SQL执行描述信息
  V_STEP_DESC VARCHAR2(1000);      --处理步骤描述
  V_ENDTIME   DATE;                --处理结束时间
  V_SQL       VARCHAR2(2000);      --自定义SQL
  V_PRT_NM    VARCHAR2(100);       --表分区名称
  E_EXPT      EXCEPTION;           --自定义异常
  I_PCN       INTEGER;             --分区校验

BEGIN
  D_DATE       := TO_DATE(I_DATADATE,'YYYYMMDD'); --转化日期类型
  V_DATEID     := TO_CHAR(I_DATADATE);
  O_ERRCODE    :=0;

  --生成执行delete语句，逐个表删除数据
    --获取配置表信息（ETL_DATA_CLEANUP_CONF）
  FOR DEL_INFO IN
   (SELECT 'DELETE FROM '||SCH_NAME||'.'||A.TABLE_NAME||' WHERE '||
           CASE WHEN COL_TYPE = 'VARCHAR2' THEN ' TO_DATE('||COL_NAME||','''||COL_FORMAT||''')=DATE'''||TO_CHAR(TO_DATE(V_DATEID,'YYYYMMDD')-NVL(KEEP_NUM,0),'YYYY-MM-DD')||''''
                WHEN COL_TYPE = 'DATE' THEN COL_NAME||'=DATE'''||TO_CHAR(TO_DATE(V_DATEID,'YYYYMMDD')-NVL(KEEP_NUM,0),'YYYY-MM-DD')||''''
            END AS EXEC_SQL,
           CASE WHEN COL_TYPE = 'VARCHAR2' THEN --VARCHAR2类型的数据清理
                  CASE KEEP_TYPE
                    WHEN 'W' THEN ' AND TO_CHAR(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''), ''D'') <> ''1'')' --保留周末
                    WHEN 'X' THEN ' AND NOT (TO_CHAR(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''), ''DD'') IN (10, 20) '||
                                  'OR TO_DATE('||COL_NAME||','''||COL_FORMAT||''') = LAST_DAY(TO_DATE('||COL_NAME||','''||COL_FORMAT||''')))'--保留旬末
                    WHEN 'M' THEN ' AND TO_DATE('||COL_NAME||','''||COL_FORMAT||''')<>LAST_DAY(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''))'--保留月末
                    WHEN 'Q' THEN ' AND NOT (EXTRACT(MONTH FROM TO_DATE('||COL_NAME||','''||COL_FORMAT||''')) IN (3, 6, 9, 12) '||
                                  'AND TO_CHAR(TO_DATE('||COL_NAME||','''||COL_FORMAT||'''), ''DD'') = TO_CHAR(LAST_DAY(TO_DATE('||COL_NAME||','''||COL_FORMAT||''')), ''DD''))'--保留季末
                    WHEN 'HY' THEN ' AND NOT (EXTRACT(MONTH FROM TO_DATE('||COL_NAME||','''||COL_FORMAT||''')) = 6 '||
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
                    WHEN 'Q' THEN ' AND NOT (EXTRACT(MONTH FROM '||COL_NAME||') IN (3, 6, 9, 12) '||
                                  'AND TO_CHAR('||COL_NAME||', ''DD'') = TO_CHAR(LAST_DAY('||COL_NAME||'), ''DD''))'--保留季末
                    WHEN 'HY' THEN ' AND NOT (EXTRACT(MONTH FROM '||COL_NAME||') = 6 '||
                                  'AND TO_CHAR('||COL_NAME||', ''DD'') = TO_CHAR(LAST_DAY('||COL_NAME||'), ''DD''))'--保留半年末
                    WHEN 'Y' THEN ' AND NOT (EXTRACT(MONTH FROM '||COL_NAME||') = 12 '||
                                  'AND TO_CHAR('||COL_NAME||', ''DD'') = ''31'')' --保留年末
                    WHEN 'N' THEN '' --无保留
                    ELSE '1'         --未设置清理策略
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
      DBMS_OUTPUT.PUT_LINE('EXECUTE: ' || DEL_INFO.TABLE_NAME||DEL_INFO.KEEP_SQL);

      EXCEPTION
        WHEN E_EXPT THEN --
             V_STEP_DESC := V_DATEID||'发生异常！详细信息为： ' || SUBSTR(SQLERRM, 1, 280);
             UPDATE ETL_DATA_CLEANUP_CONF A SET EXEC_STATUS = V_STEP_DESC
              WHERE A.SCH_NAME = DEL_INFO.SCH_NAME
                AND A.TABLE_NAME = DEL_INFO.TABLE_NAME;
             COMMIT;
        WHEN OTHERS THEN
             V_STEP_DESC := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
             UPDATE ETL_DATA_CLEANUP_CONF A SET EXEC_STATUS = V_SQLMSG
              WHERE A.SCH_NAME = DEL_INFO.SCH_NAME
                AND A.TABLE_NAME = DEL_INFO.TABLE_NAME;
             COMMIT;
      END;
 END LOOP;



EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE   := '1'; --将SQL错误编号赋植给O_ERRCODE
    V_STEP_DESC := '发生异常！详细信息为： ' || SUBSTR(SQLERRM, 1, 280);
    V_ENDTIME  := SYSDATE;
    DBMS_OUTPUT.PUT_LINE(V_STEP_DESC);
    --记录异常信息

    --ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
END ETL_YUSYS_TEST;
/

