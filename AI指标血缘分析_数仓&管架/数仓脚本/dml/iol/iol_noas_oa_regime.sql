/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_regime
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
create table ${iol_schema}.noas_oa_regime_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_regime;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_regime_op purge;
drop table ${iol_schema}.noas_oa_regime_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_regime_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_regime where 0=1;

create table ${iol_schema}.noas_oa_regime_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_regime where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_regime_cl(
            regime_id -- 制度标识
            ,flow_type_id -- 当前流程ID
            ,regime_name -- 制度名称
            ,data_type -- 类别(1-合规2-未分类)
            ,character_num -- 文号
            ,version_num -- 版本号
            ,regime_type -- 制度类型(总行:1-基本制度,2-管理办法,3-操作规范分行:1-管理办法2-操作规范)
            ,attachment_id -- 附件ID
            ,formulate_date -- 拟稿时间
            ,validity_date -- 有效期(年)
            ,regime_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
            ,formulate_dept -- 制定部门(拟稿人部门)
            ,release_person -- 发布人
            ,release_dept -- 发布部门(发布人所在部门)
            ,release_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
            ,remark -- 备注
            ,detail -- 内容
            ,allow_reader -- 允许读者
            ,release_date -- 签发时间
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,process_ins_id -- 流程实例ID
            ,useful_time -- 版本有效期截止时间
            ,sign_leader -- 签发人
            ,writter -- 拟稿人姓名
            ,abolish_date -- 制度废止时间
            ,business_dimension -- 业务维度
            ,abolish_person -- 制度废止人姓名
            ,security_level -- 安全级别(1-全行可见,2-总行和本分行可见)
            ,abolish_type -- 废止经办(1-系统废止/2-手动废止人员姓名)
            ,abolish_oper_time -- 废止操作
            ,abolish_source -- 制度废止原因(《关于废止**办法的通知》（粤华银发[2017]**号）)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_regime_op(
            regime_id -- 制度标识
            ,flow_type_id -- 当前流程ID
            ,regime_name -- 制度名称
            ,data_type -- 类别(1-合规2-未分类)
            ,character_num -- 文号
            ,version_num -- 版本号
            ,regime_type -- 制度类型(总行:1-基本制度,2-管理办法,3-操作规范分行:1-管理办法2-操作规范)
            ,attachment_id -- 附件ID
            ,formulate_date -- 拟稿时间
            ,validity_date -- 有效期(年)
            ,regime_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
            ,formulate_dept -- 制定部门(拟稿人部门)
            ,release_person -- 发布人
            ,release_dept -- 发布部门(发布人所在部门)
            ,release_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
            ,remark -- 备注
            ,detail -- 内容
            ,allow_reader -- 允许读者
            ,release_date -- 签发时间
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,process_ins_id -- 流程实例ID
            ,useful_time -- 版本有效期截止时间
            ,sign_leader -- 签发人
            ,writter -- 拟稿人姓名
            ,abolish_date -- 制度废止时间
            ,business_dimension -- 业务维度
            ,abolish_person -- 制度废止人姓名
            ,security_level -- 安全级别(1-全行可见,2-总行和本分行可见)
            ,abolish_type -- 废止经办(1-系统废止/2-手动废止人员姓名)
            ,abolish_oper_time -- 废止操作
            ,abolish_source -- 制度废止原因(《关于废止**办法的通知》（粤华银发[2017]**号）)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.regime_id, o.regime_id) as regime_id -- 制度标识
    ,nvl(n.flow_type_id, o.flow_type_id) as flow_type_id -- 当前流程ID
    ,nvl(n.regime_name, o.regime_name) as regime_name -- 制度名称
    ,nvl(n.data_type, o.data_type) as data_type -- 类别(1-合规2-未分类)
    ,nvl(n.character_num, o.character_num) as character_num -- 文号
    ,nvl(n.version_num, o.version_num) as version_num -- 版本号
    ,nvl(n.regime_type, o.regime_type) as regime_type -- 制度类型(总行:1-基本制度,2-管理办法,3-操作规范分行:1-管理办法2-操作规范)
    ,nvl(n.attachment_id, o.attachment_id) as attachment_id -- 附件ID
    ,nvl(n.formulate_date, o.formulate_date) as formulate_date -- 拟稿时间
    ,nvl(n.validity_date, o.validity_date) as validity_date -- 有效期(年)
    ,nvl(n.regime_status, o.regime_status) as regime_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
    ,nvl(n.formulate_dept, o.formulate_dept) as formulate_dept -- 制定部门(拟稿人部门)
    ,nvl(n.release_person, o.release_person) as release_person -- 发布人
    ,nvl(n.release_dept, o.release_dept) as release_dept -- 发布部门(发布人所在部门)
    ,nvl(n.release_status, o.release_status) as release_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.detail, o.detail) as detail -- 内容
    ,nvl(n.allow_reader, o.allow_reader) as allow_reader -- 允许读者
    ,nvl(n.release_date, o.release_date) as release_date -- 签发时间
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- bosent自带最后修改时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- bosent自带最后修改时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- bosent自带创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- bosent自带创建时间
    ,nvl(n.process_ins_id, o.process_ins_id) as process_ins_id -- 流程实例ID
    ,nvl(n.useful_time, o.useful_time) as useful_time -- 版本有效期截止时间
    ,nvl(n.sign_leader, o.sign_leader) as sign_leader -- 签发人
    ,nvl(n.writter, o.writter) as writter -- 拟稿人姓名
    ,nvl(n.abolish_date, o.abolish_date) as abolish_date -- 制度废止时间
    ,nvl(n.business_dimension, o.business_dimension) as business_dimension -- 业务维度
    ,nvl(n.abolish_person, o.abolish_person) as abolish_person -- 制度废止人姓名
    ,nvl(n.security_level, o.security_level) as security_level -- 安全级别(1-全行可见,2-总行和本分行可见)
    ,nvl(n.abolish_type, o.abolish_type) as abolish_type -- 废止经办(1-系统废止/2-手动废止人员姓名)
    ,nvl(n.abolish_oper_time, o.abolish_oper_time) as abolish_oper_time -- 废止操作
    ,nvl(n.abolish_source, o.abolish_source) as abolish_source -- 制度废止原因(《关于废止**办法的通知》（粤华银发[2017]**号）)
    ,case when
            n.regime_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.regime_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.regime_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_regime_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_regime where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.regime_id = n.regime_id
where (
        o.regime_id is null
    )
    or (
        n.regime_id is null
    )
    or (
        o.flow_type_id <> n.flow_type_id
        or o.regime_name <> n.regime_name
        or o.data_type <> n.data_type
        or o.character_num <> n.character_num
        or o.version_num <> n.version_num
        or o.regime_type <> n.regime_type
        or o.attachment_id <> n.attachment_id
        or o.formulate_date <> n.formulate_date
        or o.validity_date <> n.validity_date
        or o.regime_status <> n.regime_status
        or o.formulate_dept <> n.formulate_dept
        or o.release_person <> n.release_person
        or o.release_dept <> n.release_dept
        or o.release_status <> n.release_status
        or o.remark <> n.remark
        or o.detail <> n.detail
        or o.allow_reader <> n.allow_reader
        or o.release_date <> n.release_date
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.process_ins_id <> n.process_ins_id
        or o.useful_time <> n.useful_time
        or o.sign_leader <> n.sign_leader
        or o.writter <> n.writter
        or o.abolish_date <> n.abolish_date
        or o.business_dimension <> n.business_dimension
        or o.abolish_person <> n.abolish_person
        or o.security_level <> n.security_level
        or o.abolish_type <> n.abolish_type
        or o.abolish_oper_time <> n.abolish_oper_time
        or o.abolish_source <> n.abolish_source
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_regime_cl(
            regime_id -- 制度标识
            ,flow_type_id -- 当前流程ID
            ,regime_name -- 制度名称
            ,data_type -- 类别(1-合规2-未分类)
            ,character_num -- 文号
            ,version_num -- 版本号
            ,regime_type -- 制度类型(总行:1-基本制度,2-管理办法,3-操作规范分行:1-管理办法2-操作规范)
            ,attachment_id -- 附件ID
            ,formulate_date -- 拟稿时间
            ,validity_date -- 有效期(年)
            ,regime_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
            ,formulate_dept -- 制定部门(拟稿人部门)
            ,release_person -- 发布人
            ,release_dept -- 发布部门(发布人所在部门)
            ,release_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
            ,remark -- 备注
            ,detail -- 内容
            ,allow_reader -- 允许读者
            ,release_date -- 签发时间
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,process_ins_id -- 流程实例ID
            ,useful_time -- 版本有效期截止时间
            ,sign_leader -- 签发人
            ,writter -- 拟稿人姓名
            ,abolish_date -- 制度废止时间
            ,business_dimension -- 业务维度
            ,abolish_person -- 制度废止人姓名
            ,security_level -- 安全级别(1-全行可见,2-总行和本分行可见)
            ,abolish_type -- 废止经办(1-系统废止/2-手动废止人员姓名)
            ,abolish_oper_time -- 废止操作
            ,abolish_source -- 制度废止原因(《关于废止**办法的通知》（粤华银发[2017]**号）)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_regime_op(
            regime_id -- 制度标识
            ,flow_type_id -- 当前流程ID
            ,regime_name -- 制度名称
            ,data_type -- 类别(1-合规2-未分类)
            ,character_num -- 文号
            ,version_num -- 版本号
            ,regime_type -- 制度类型(总行:1-基本制度,2-管理办法,3-操作规范分行:1-管理办法2-操作规范)
            ,attachment_id -- 附件ID
            ,formulate_date -- 拟稿时间
            ,validity_date -- 有效期(年)
            ,regime_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
            ,formulate_dept -- 制定部门(拟稿人部门)
            ,release_person -- 发布人
            ,release_dept -- 发布部门(发布人所在部门)
            ,release_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
            ,remark -- 备注
            ,detail -- 内容
            ,allow_reader -- 允许读者
            ,release_date -- 签发时间
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,process_ins_id -- 流程实例ID
            ,useful_time -- 版本有效期截止时间
            ,sign_leader -- 签发人
            ,writter -- 拟稿人姓名
            ,abolish_date -- 制度废止时间
            ,business_dimension -- 业务维度
            ,abolish_person -- 制度废止人姓名
            ,security_level -- 安全级别(1-全行可见,2-总行和本分行可见)
            ,abolish_type -- 废止经办(1-系统废止/2-手动废止人员姓名)
            ,abolish_oper_time -- 废止操作
            ,abolish_source -- 制度废止原因(《关于废止**办法的通知》（粤华银发[2017]**号）)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.regime_id -- 制度标识
    ,o.flow_type_id -- 当前流程ID
    ,o.regime_name -- 制度名称
    ,o.data_type -- 类别(1-合规2-未分类)
    ,o.character_num -- 文号
    ,o.version_num -- 版本号
    ,o.regime_type -- 制度类型(总行:1-基本制度,2-管理办法,3-操作规范分行:1-管理办法2-操作规范)
    ,o.attachment_id -- 附件ID
    ,o.formulate_date -- 拟稿时间
    ,o.validity_date -- 有效期(年)
    ,o.regime_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
    ,o.formulate_dept -- 制定部门(拟稿人部门)
    ,o.release_person -- 发布人
    ,o.release_dept -- 发布部门(发布人所在部门)
    ,o.release_status -- 制度状态(1-有效,2-修订,3-废止,4-有效期限届满)
    ,o.remark -- 备注
    ,o.detail -- 内容
    ,o.allow_reader -- 允许读者
    ,o.release_date -- 签发时间
    ,o.last_updated_stamp -- bosent自带最后修改时间
    ,o.last_updated_tx_stamp -- bosent自带最后修改时间
    ,o.created_stamp -- bosent自带创建时间
    ,o.created_tx_stamp -- bosent自带创建时间
    ,o.process_ins_id -- 流程实例ID
    ,o.useful_time -- 版本有效期截止时间
    ,o.sign_leader -- 签发人
    ,o.writter -- 拟稿人姓名
    ,o.abolish_date -- 制度废止时间
    ,o.business_dimension -- 业务维度
    ,o.abolish_person -- 制度废止人姓名
    ,o.security_level -- 安全级别(1-全行可见,2-总行和本分行可见)
    ,o.abolish_type -- 废止经办(1-系统废止/2-手动废止人员姓名)
    ,o.abolish_oper_time -- 废止操作
    ,o.abolish_source -- 制度废止原因(《关于废止**办法的通知》（粤华银发[2017]**号）)
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.noas_oa_regime_bk o
    left join ${iol_schema}.noas_oa_regime_op n
        on
            o.regime_id = n.regime_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_regime_cl d
        on
            o.regime_id = d.regime_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.noas_oa_regime;

-- 4.2 exchange partition
alter table ${iol_schema}.noas_oa_regime exchange partition p_19000101 with table ${iol_schema}.noas_oa_regime_cl;
alter table ${iol_schema}.noas_oa_regime exchange partition p_20991231 with table ${iol_schema}.noas_oa_regime_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_regime to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_regime_op purge;
drop table ${iol_schema}.noas_oa_regime_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_regime_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_regime',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
