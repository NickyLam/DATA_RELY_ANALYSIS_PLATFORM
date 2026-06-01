/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_model_micro_risk_info
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
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.hgls_model_micro_risk_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_model_micro_risk_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_model_micro_risk_info_op purge;
drop table ${iol_schema}.hgls_model_micro_risk_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_model_micro_risk_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_model_micro_risk_info where 0=1;

create table ${iol_schema}.hgls_model_micro_risk_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_model_micro_risk_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_model_micro_risk_info_cl(
            risk_id -- 主键id
            ,loan_id -- 进件id
            ,process_type -- 审批类型：1、准入模型输出结果 2、征信模型输出结果 3、业务申请评分模型输出结果 4、风险核查模型输出结果 5、免下户额度模型输出结果；6、企业征信模型输出结果 7、流水模型输出结果 8、交叉检验模型输出结果 9、综合评分授信模型
            ,biz_type -- 业务类型０个人信息１配偶信息２共同借款人３担保人4微信借款
            ,biz_id -- 信息来源主表ID
            ,type -- 风险类型大类：根据dict字典值查询，risk_type
            ,risk_type -- 风险类型小类：根据dict字典值查询，risk_small_type
            ,risk_level -- 风险等级：根据dict字典值查询risk_level
            ,risk_info -- 风险点内容
            ,term -- 话术主键
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,point -- 是否需要高亮展示1需要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_model_micro_risk_info_op(
            risk_id -- 主键id
            ,loan_id -- 进件id
            ,process_type -- 审批类型：1、准入模型输出结果 2、征信模型输出结果 3、业务申请评分模型输出结果 4、风险核查模型输出结果 5、免下户额度模型输出结果；6、企业征信模型输出结果 7、流水模型输出结果 8、交叉检验模型输出结果 9、综合评分授信模型
            ,biz_type -- 业务类型０个人信息１配偶信息２共同借款人３担保人4微信借款
            ,biz_id -- 信息来源主表ID
            ,type -- 风险类型大类：根据dict字典值查询，risk_type
            ,risk_type -- 风险类型小类：根据dict字典值查询，risk_small_type
            ,risk_level -- 风险等级：根据dict字典值查询risk_level
            ,risk_info -- 风险点内容
            ,term -- 话术主键
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,point -- 是否需要高亮展示1需要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.risk_id, o.risk_id) as risk_id -- 主键id
    ,nvl(n.loan_id, o.loan_id) as loan_id -- 进件id
    ,nvl(n.process_type, o.process_type) as process_type -- 审批类型：1、准入模型输出结果 2、征信模型输出结果 3、业务申请评分模型输出结果 4、风险核查模型输出结果 5、免下户额度模型输出结果；6、企业征信模型输出结果 7、流水模型输出结果 8、交叉检验模型输出结果 9、综合评分授信模型
    ,nvl(n.biz_type, o.biz_type) as biz_type -- 业务类型０个人信息１配偶信息２共同借款人３担保人4微信借款
    ,nvl(n.biz_id, o.biz_id) as biz_id -- 信息来源主表ID
    ,nvl(n.type, o.type) as type -- 风险类型大类：根据dict字典值查询，risk_type
    ,nvl(n.risk_type, o.risk_type) as risk_type -- 风险类型小类：根据dict字典值查询，risk_small_type
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险等级：根据dict字典值查询risk_level
    ,nvl(n.risk_info, o.risk_info) as risk_info -- 风险点内容
    ,nvl(n.term, o.term) as term -- 话术主键
    ,nvl(n.create_date, o.create_date) as create_date -- 申请日期
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.point, o.point) as point -- 是否需要高亮展示1需要
    ,case when
            n.risk_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.risk_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.risk_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_model_micro_risk_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_model_micro_risk_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.risk_id = n.risk_id
where (
        o.risk_id is null
    )
    or (
        n.risk_id is null
    )
    or (
        o.loan_id <> n.loan_id
        or o.process_type <> n.process_type
        or o.biz_type <> n.biz_type
        or o.biz_id <> n.biz_id
        or o.type <> n.type
        or o.risk_type <> n.risk_type
        or o.risk_level <> n.risk_level
        or o.risk_info <> n.risk_info
        or o.term <> n.term
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.point <> n.point
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_model_micro_risk_info_cl(
            risk_id -- 主键id
            ,loan_id -- 进件id
            ,process_type -- 审批类型：1、准入模型输出结果 2、征信模型输出结果 3、业务申请评分模型输出结果 4、风险核查模型输出结果 5、免下户额度模型输出结果；6、企业征信模型输出结果 7、流水模型输出结果 8、交叉检验模型输出结果 9、综合评分授信模型
            ,biz_type -- 业务类型０个人信息１配偶信息２共同借款人３担保人4微信借款
            ,biz_id -- 信息来源主表ID
            ,type -- 风险类型大类：根据dict字典值查询，risk_type
            ,risk_type -- 风险类型小类：根据dict字典值查询，risk_small_type
            ,risk_level -- 风险等级：根据dict字典值查询risk_level
            ,risk_info -- 风险点内容
            ,term -- 话术主键
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,point -- 是否需要高亮展示1需要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_model_micro_risk_info_op(
            risk_id -- 主键id
            ,loan_id -- 进件id
            ,process_type -- 审批类型：1、准入模型输出结果 2、征信模型输出结果 3、业务申请评分模型输出结果 4、风险核查模型输出结果 5、免下户额度模型输出结果；6、企业征信模型输出结果 7、流水模型输出结果 8、交叉检验模型输出结果 9、综合评分授信模型
            ,biz_type -- 业务类型０个人信息１配偶信息２共同借款人３担保人4微信借款
            ,biz_id -- 信息来源主表ID
            ,type -- 风险类型大类：根据dict字典值查询，risk_type
            ,risk_type -- 风险类型小类：根据dict字典值查询，risk_small_type
            ,risk_level -- 风险等级：根据dict字典值查询risk_level
            ,risk_info -- 风险点内容
            ,term -- 话术主键
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,point -- 是否需要高亮展示1需要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.risk_id -- 主键id
    ,o.loan_id -- 进件id
    ,o.process_type -- 审批类型：1、准入模型输出结果 2、征信模型输出结果 3、业务申请评分模型输出结果 4、风险核查模型输出结果 5、免下户额度模型输出结果；6、企业征信模型输出结果 7、流水模型输出结果 8、交叉检验模型输出结果 9、综合评分授信模型
    ,o.biz_type -- 业务类型０个人信息１配偶信息２共同借款人３担保人4微信借款
    ,o.biz_id -- 信息来源主表ID
    ,o.type -- 风险类型大类：根据dict字典值查询，risk_type
    ,o.risk_type -- 风险类型小类：根据dict字典值查询，risk_small_type
    ,o.risk_level -- 风险等级：根据dict字典值查询risk_level
    ,o.risk_info -- 风险点内容
    ,o.term -- 话术主键
    ,o.create_date -- 申请日期
    ,o.update_date -- 更新时间
    ,o.point -- 是否需要高亮展示1需要
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.hgls_model_micro_risk_info_bk o
    left join ${iol_schema}.hgls_model_micro_risk_info_op n
        on
            o.risk_id = n.risk_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_model_micro_risk_info_cl d
        on
            o.risk_id = d.risk_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_model_micro_risk_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_model_micro_risk_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_model_micro_risk_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_model_micro_risk_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_model_micro_risk_info exchange partition p_${batch_date} with table ${iol_schema}.hgls_model_micro_risk_info_cl;
alter table ${iol_schema}.hgls_model_micro_risk_info exchange partition p_20991231 with table ${iol_schema}.hgls_model_micro_risk_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_model_micro_risk_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_model_micro_risk_info_op purge;
drop table ${iol_schema}.hgls_model_micro_risk_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_model_micro_risk_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_model_micro_risk_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
