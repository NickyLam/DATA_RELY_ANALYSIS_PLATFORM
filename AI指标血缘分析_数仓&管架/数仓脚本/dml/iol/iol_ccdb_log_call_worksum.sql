/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_log_call_worksum
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.ccdb_log_call_worksum_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccdb_log_call_worksum;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_log_call_worksum_op purge;
drop table ${iol_schema}.ccdb_log_call_worksum_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_log_call_worksum_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_log_call_worksum where 0=1;

create table ${iol_schema}.ccdb_log_call_worksum_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_log_call_worksum where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ccdb_log_call_worksum_op(
        connect_id -- 呼叫流水号
        ,cust_name -- 客户姓名
        ,cust_gender -- 客户性别
        ,cust_type -- 客户类型
        ,cust_no -- 客户号
        ,cust_paper_type -- 客户证件类型
        ,cust_paper_id -- 客户证件号
        ,card_no -- 卡号
        ,card_type -- 卡类型
        ,sum_input -- 通话内容
        ,agent_id -- agentid
        ,emp_code -- 员工编号
        ,sum_time -- 应答时间
        ,call_no -- 呼入/呼出号码
        ,account_code -- 用户号
        ,sum_no -- 主键
        ,skill_group_id -- 技能组id
        ,service_type -- 服务类型
        ,proc_level -- 处理级别
        ,appraise -- 对客户评价
        ,sign_flag -- 签约标志
        ,satisfied_type -- 满意度
        ,acw_end_time -- 结束事后处理时间
        ,call_type -- 呼叫类型,3呼出,除3以外都是呼入
        ,org_code -- 座席组织机构id
        ,org_name -- 座席组织机构名称
        ,certi_type -- 凭证类型
        ,tsringtime -- 振铃/外呼时间
        ,tspicktime -- 摘机时间
        ,tshangtime -- 挂机时间
        ,tsacwtime -- 处理结束时间
        ,asumagent -- 受理坐席
        ,tsproctime -- 处理时间
        ,aprocresult -- 处理结果
        ,aprocagent -- 处理座席
        ,aprocstate -- 处理状态
        ,aplanno -- 
        ,ataskno -- 
        ,idcardno -- 
        ,mobiletel -- 
        ,hometel -- 
        ,officetel -- 
        ,acustomerid -- 
        ,language -- 语种(英语（en）普通话（cn）)
        ,extension -- 坐席分机号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.connect_id -- 呼叫流水号
    ,n.cust_name -- 客户姓名
    ,n.cust_gender -- 客户性别
    ,n.cust_type -- 客户类型
    ,n.cust_no -- 客户号
    ,n.cust_paper_type -- 客户证件类型
    ,n.cust_paper_id -- 客户证件号
    ,n.card_no -- 卡号
    ,n.card_type -- 卡类型
    ,n.sum_input -- 通话内容
    ,n.agent_id -- agentid
    ,n.emp_code -- 员工编号
    ,n.sum_time -- 应答时间
    ,n.call_no -- 呼入/呼出号码
    ,n.account_code -- 用户号
    ,n.sum_no -- 主键
    ,n.skill_group_id -- 技能组id
    ,n.service_type -- 服务类型
    ,n.proc_level -- 处理级别
    ,n.appraise -- 对客户评价
    ,n.sign_flag -- 签约标志
    ,n.satisfied_type -- 满意度
    ,n.acw_end_time -- 结束事后处理时间
    ,n.call_type -- 呼叫类型,3呼出,除3以外都是呼入
    ,n.org_code -- 座席组织机构id
    ,n.org_name -- 座席组织机构名称
    ,n.certi_type -- 凭证类型
    ,n.tsringtime -- 振铃/外呼时间
    ,n.tspicktime -- 摘机时间
    ,n.tshangtime -- 挂机时间
    ,n.tsacwtime -- 处理结束时间
    ,n.asumagent -- 受理坐席
    ,n.tsproctime -- 处理时间
    ,n.aprocresult -- 处理结果
    ,n.aprocagent -- 处理座席
    ,n.aprocstate -- 处理状态
    ,n.aplanno -- 
    ,n.ataskno -- 
    ,n.idcardno -- 
    ,n.mobiletel -- 
    ,n.hometel -- 
    ,n.officetel -- 
    ,n.acustomerid -- 
    ,n.language -- 语种(英语（en）普通话（cn）)
    ,n.extension -- 坐席分机号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccdb_log_call_worksum_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.ccdb_log_call_worksum where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sum_no = n.sum_no
where (
        o.sum_no is null
    )
    or (
        o.connect_id <> n.connect_id
        or o.cust_name <> n.cust_name
        or o.cust_gender <> n.cust_gender
        or o.cust_type <> n.cust_type
        or o.cust_no <> n.cust_no
        or o.cust_paper_type <> n.cust_paper_type
        or o.cust_paper_id <> n.cust_paper_id
        or o.card_no <> n.card_no
        or o.card_type <> n.card_type
        or o.sum_input <> n.sum_input
        or o.agent_id <> n.agent_id
        or o.emp_code <> n.emp_code
        or o.sum_time <> n.sum_time
        or o.call_no <> n.call_no
        or o.account_code <> n.account_code
        or o.skill_group_id <> n.skill_group_id
        or o.service_type <> n.service_type
        or o.proc_level <> n.proc_level
        or o.appraise <> n.appraise
        or o.sign_flag <> n.sign_flag
        or o.satisfied_type <> n.satisfied_type
        or o.acw_end_time <> n.acw_end_time
        or o.call_type <> n.call_type
        or o.org_code <> n.org_code
        or o.org_name <> n.org_name
        or o.certi_type <> n.certi_type
        or o.tsringtime <> n.tsringtime
        or o.tspicktime <> n.tspicktime
        or o.tshangtime <> n.tshangtime
        or o.tsacwtime <> n.tsacwtime
        or o.asumagent <> n.asumagent
        or o.tsproctime <> n.tsproctime
        or o.aprocresult <> n.aprocresult
        or o.aprocagent <> n.aprocagent
        or o.aprocstate <> n.aprocstate
        or o.aplanno <> n.aplanno
        or o.ataskno <> n.ataskno
        or o.idcardno <> n.idcardno
        or o.mobiletel <> n.mobiletel
        or o.hometel <> n.hometel
        or o.officetel <> n.officetel
        or o.acustomerid <> n.acustomerid
        or o.language <> n.language
        or o.extension <> n.extension
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_log_call_worksum_cl(
            connect_id -- 呼叫流水号
        ,cust_name -- 客户姓名
        ,cust_gender -- 客户性别
        ,cust_type -- 客户类型
        ,cust_no -- 客户号
        ,cust_paper_type -- 客户证件类型
        ,cust_paper_id -- 客户证件号
        ,card_no -- 卡号
        ,card_type -- 卡类型
        ,sum_input -- 通话内容
        ,agent_id -- agentid
        ,emp_code -- 员工编号
        ,sum_time -- 应答时间
        ,call_no -- 呼入/呼出号码
        ,account_code -- 用户号
        ,sum_no -- 主键
        ,skill_group_id -- 技能组id
        ,service_type -- 服务类型
        ,proc_level -- 处理级别
        ,appraise -- 对客户评价
        ,sign_flag -- 签约标志
        ,satisfied_type -- 满意度
        ,acw_end_time -- 结束事后处理时间
        ,call_type -- 呼叫类型,3呼出,除3以外都是呼入
        ,org_code -- 座席组织机构id
        ,org_name -- 座席组织机构名称
        ,certi_type -- 凭证类型
        ,tsringtime -- 振铃/外呼时间
        ,tspicktime -- 摘机时间
        ,tshangtime -- 挂机时间
        ,tsacwtime -- 处理结束时间
        ,asumagent -- 受理坐席
        ,tsproctime -- 处理时间
        ,aprocresult -- 处理结果
        ,aprocagent -- 处理座席
        ,aprocstate -- 处理状态
        ,aplanno -- 
        ,ataskno -- 
        ,idcardno -- 
        ,mobiletel -- 
        ,hometel -- 
        ,officetel -- 
        ,acustomerid -- 
        ,language -- 语种(英语（en）普通话（cn）)
        ,extension -- 坐席分机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_log_call_worksum_op(
            connect_id -- 呼叫流水号
        ,cust_name -- 客户姓名
        ,cust_gender -- 客户性别
        ,cust_type -- 客户类型
        ,cust_no -- 客户号
        ,cust_paper_type -- 客户证件类型
        ,cust_paper_id -- 客户证件号
        ,card_no -- 卡号
        ,card_type -- 卡类型
        ,sum_input -- 通话内容
        ,agent_id -- agentid
        ,emp_code -- 员工编号
        ,sum_time -- 应答时间
        ,call_no -- 呼入/呼出号码
        ,account_code -- 用户号
        ,sum_no -- 主键
        ,skill_group_id -- 技能组id
        ,service_type -- 服务类型
        ,proc_level -- 处理级别
        ,appraise -- 对客户评价
        ,sign_flag -- 签约标志
        ,satisfied_type -- 满意度
        ,acw_end_time -- 结束事后处理时间
        ,call_type -- 呼叫类型,3呼出,除3以外都是呼入
        ,org_code -- 座席组织机构id
        ,org_name -- 座席组织机构名称
        ,certi_type -- 凭证类型
        ,tsringtime -- 振铃/外呼时间
        ,tspicktime -- 摘机时间
        ,tshangtime -- 挂机时间
        ,tsacwtime -- 处理结束时间
        ,asumagent -- 受理坐席
        ,tsproctime -- 处理时间
        ,aprocresult -- 处理结果
        ,aprocagent -- 处理座席
        ,aprocstate -- 处理状态
        ,aplanno -- 
        ,ataskno -- 
        ,idcardno -- 
        ,mobiletel -- 
        ,hometel -- 
        ,officetel -- 
        ,acustomerid -- 
        ,language -- 语种(英语（en）普通话（cn）)
        ,extension -- 坐席分机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.connect_id -- 呼叫流水号
    ,o.cust_name -- 客户姓名
    ,o.cust_gender -- 客户性别
    ,o.cust_type -- 客户类型
    ,o.cust_no -- 客户号
    ,o.cust_paper_type -- 客户证件类型
    ,o.cust_paper_id -- 客户证件号
    ,o.card_no -- 卡号
    ,o.card_type -- 卡类型
    ,o.sum_input -- 通话内容
    ,o.agent_id -- agentid
    ,o.emp_code -- 员工编号
    ,o.sum_time -- 应答时间
    ,o.call_no -- 呼入/呼出号码
    ,o.account_code -- 用户号
    ,o.sum_no -- 主键
    ,o.skill_group_id -- 技能组id
    ,o.service_type -- 服务类型
    ,o.proc_level -- 处理级别
    ,o.appraise -- 对客户评价
    ,o.sign_flag -- 签约标志
    ,o.satisfied_type -- 满意度
    ,o.acw_end_time -- 结束事后处理时间
    ,o.call_type -- 呼叫类型,3呼出,除3以外都是呼入
    ,o.org_code -- 座席组织机构id
    ,o.org_name -- 座席组织机构名称
    ,o.certi_type -- 凭证类型
    ,o.tsringtime -- 振铃/外呼时间
    ,o.tspicktime -- 摘机时间
    ,o.tshangtime -- 挂机时间
    ,o.tsacwtime -- 处理结束时间
    ,o.asumagent -- 受理坐席
    ,o.tsproctime -- 处理时间
    ,o.aprocresult -- 处理结果
    ,o.aprocagent -- 处理座席
    ,o.aprocstate -- 处理状态
    ,o.aplanno -- 
    ,o.ataskno -- 
    ,o.idcardno -- 
    ,o.mobiletel -- 
    ,o.hometel -- 
    ,o.officetel -- 
    ,o.acustomerid -- 
    ,o.language -- 语种(英语（en）普通话（cn）)
    ,o.extension -- 坐席分机号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ccdb_log_call_worksum_bk o
    left join ${iol_schema}.ccdb_log_call_worksum_op n
        on
            o.sum_no = n.sum_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccdb_log_call_worksum;

-- 4.2 exchange partition
alter table ${iol_schema}.ccdb_log_call_worksum exchange partition p_19000101 with table ${iol_schema}.ccdb_log_call_worksum_cl;
alter table ${iol_schema}.ccdb_log_call_worksum exchange partition p_20991231 with table ${iol_schema}.ccdb_log_call_worksum_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_log_call_worksum to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_log_call_worksum_op purge;
drop table ${iol_schema}.ccdb_log_call_worksum_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccdb_log_call_worksum_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_log_call_worksum',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
