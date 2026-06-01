/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bcdl_tran_msg_mpcsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_bcdl_tran_msg_mpcsi1_tm purge;
alter table ${iml_schema}.evt_bcdl_tran_msg add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bcdl_tran_msg modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;


set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_bcdl_tran_msg'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
   -- dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_bcdl_tran_msg truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_bcdl_tran_msg modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
      --  dbms_output.put_line(v_sql);
        execute immediate v_sql;
      --  dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/



-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a63tpck-
insert into ${iml_schema}.evt_bcdl_tran_msg(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,corp_work_dt -- 企业工作日期
    ,corp_flow_num -- 企业流水号
    ,sign_id -- 签约编号
    ,acct_num -- 账号
    ,tran_cd -- 交易代码
    ,sorc_sys_tran_timestamp -- 源系统交易时间戳
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102051'||P1.CUSTNO||P1.ENTWORKDT||P1.ENTSEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CUSTNO -- 客户编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.ENTWORKDT) -- 企业工作日期
    ,P1.ENTSEQNO -- 企业流水号
    ,P1.SIGNNO -- 签约编号
    ,P1.ACCTNO -- 账号
    ,P1.TRNCD -- 交易代码
    ,P1.TRNTS -- 源系统交易时间戳
    ,p1.etl_dt as etl_dt -- ETL处理日期
    ,'mpcs_a63tpck' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a63tpck p1
where  1 = 1 
    AND P1.ETL_DT >= TO_DATE('${batch_date}','yyyymmdd') - 14  and p1.etl_dt <= TO_DATE('${batch_date}','yyyymmdd')
;
commit;



-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bcdl_tran_msg to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bcdl_tran_msg', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);