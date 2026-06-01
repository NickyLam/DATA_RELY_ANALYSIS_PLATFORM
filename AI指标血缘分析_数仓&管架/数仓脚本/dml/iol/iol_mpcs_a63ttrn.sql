/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a63ttrn
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a63ttrn_ex purge;
alter table ${iol_schema}.mpcs_a63ttrn add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a63ttrn'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a63ttrn truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a63ttrn add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a63ttrn_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a63ttrn where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a63ttrn(
    custno -- 
    ,entworkdt -- 
    ,entseqno -- 
    ,batentworkdt -- 
    ,batentseqno -- 
    ,workdt -- 
    ,seqno -- 
    ,step -- 
    ,centredate -- 
    ,settlestat -- 
    ,chnl -- 渠道:0-小额，1-大额，2-超级网银，3-行内
    ,chnldt -- 
    ,chnlseqno -- 
    ,hostdt -- 
    ,hostseqno -- 
    ,dataid -- 
    ,brcno -- 
    ,payacctno -- 
    ,payacctname -- 
    ,rcvacctflag -- 收款人类型:1-对私，2-对公
    ,rcvacctno -- 
    ,rcvacctname -- 
    ,rcvbankno -- 
    ,rcvbankname -- 
    ,ccy -- 币种:01-人民币
    ,ccyflag -- 钞汇标识:0-钞，1-汇
    ,trnamt -- 
    ,fee -- 
    ,memocd -- 
    ,remark -- 
    ,stat -- 状态:0-成功，1-失败，2-待处理，3-预处理中，4-账务处理中，5-待核实结果，6-已冲正
    ,rspcd -- 
    ,rspmsg -- 
    ,synts -- 
    ,syncount -- 
    ,trnts -- 
    ,fronttrcd -- 中台交易码
    ,globalseqno -- 全局流水号
    ,unique_seq_num -- 业务流水号
    ,efmipadd -- 输出ip地址
    ,efmmac -- 输出mac值
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    custno -- 
    ,entworkdt -- 
    ,entseqno -- 
    ,batentworkdt -- 
    ,batentseqno -- 
    ,workdt -- 
    ,seqno -- 
    ,step -- 
    ,centredate -- 
    ,settlestat -- 
    ,chnl -- 渠道:0-小额，1-大额，2-超级网银，3-行内
    ,chnldt -- 
    ,chnlseqno -- 
    ,hostdt -- 
    ,hostseqno -- 
    ,dataid -- 
    ,brcno -- 
    ,payacctno -- 
    ,payacctname -- 
    ,rcvacctflag -- 收款人类型:1-对私，2-对公
    ,rcvacctno -- 
    ,rcvacctname -- 
    ,rcvbankno -- 
    ,rcvbankname -- 
    ,ccy -- 币种:01-人民币
    ,ccyflag -- 钞汇标识:0-钞，1-汇
    ,trnamt -- 
    ,fee -- 
    ,memocd -- 
    ,remark -- 
    ,stat -- 状态:0-成功，1-失败，2-待处理，3-预处理中，4-账务处理中，5-待核实结果，6-已冲正
    ,rspcd -- 
    ,rspmsg -- 
    ,synts -- 
    ,syncount -- 
    ,trnts -- 
    ,fronttrcd -- 中台交易码
    ,globalseqno -- 全局流水号
    ,unique_seq_num -- 业务流水号
    ,efmipadd -- 输出ip地址
    ,efmmac -- 输出mac值
    ,to_date(entworkdt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a63ttrn
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a63ttrn to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a63ttrn_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a63ttrn',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);