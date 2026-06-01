/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_ebank_property_pool
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_ebank_property_pool
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_ebank_property_pool purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_ebank_property_pool(
    id number(22) -- 
    ,txn_type varchar2(3) -- 业务类型 lr-理财质押入池 lc-理财质押解除
    ,property_id number(22) -- 资产id 关联“customer_property_info”的id
    ,app_date varchar2(12) -- 网银操作员申请指令日期
    ,app_status varchar2(3) -- 申请状态 1-申请中 2-驳回申请 3-审批中 4-申请通过
    ,reason varchar2(384) -- 驳回理由
    ,cust_no varchar2(30) -- 客户号
    ,ebank_seq_no varchar2(75) -- 网银流水号
    ,branch_id number(22) -- 所属机构 票所属机构
    ,last_upd_oper_id number(22) -- 最后修改操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,int_tm timestamp -- 插入时间 初始插入时间戳 yyyy-mm-dd hh:mm:ss.0
    ,misc varchar2(768) -- 备注 保留
    ,chn_src varchar2(15) -- 渠道来源 系统英文简称
    ,ebank_oper varchar2(192) -- 网银提交人
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdps_ebank_property_pool to ${iml_schema};
grant select on ${iol_schema}.bdps_ebank_property_pool to ${icl_schema};
grant select on ${iol_schema}.bdps_ebank_property_pool to ${idl_schema};
grant select on ${iol_schema}.bdps_ebank_property_pool to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_ebank_property_pool is '交易门户资产交易任务池表';
comment on column ${iol_schema}.bdps_ebank_property_pool.id is '';
comment on column ${iol_schema}.bdps_ebank_property_pool.txn_type is '业务类型 lr-理财质押入池 lc-理财质押解除';
comment on column ${iol_schema}.bdps_ebank_property_pool.property_id is '资产id 关联“customer_property_info”的id';
comment on column ${iol_schema}.bdps_ebank_property_pool.app_date is '网银操作员申请指令日期';
comment on column ${iol_schema}.bdps_ebank_property_pool.app_status is '申请状态 1-申请中 2-驳回申请 3-审批中 4-申请通过';
comment on column ${iol_schema}.bdps_ebank_property_pool.reason is '驳回理由';
comment on column ${iol_schema}.bdps_ebank_property_pool.cust_no is '客户号';
comment on column ${iol_schema}.bdps_ebank_property_pool.ebank_seq_no is '网银流水号';
comment on column ${iol_schema}.bdps_ebank_property_pool.branch_id is '所属机构 票所属机构';
comment on column ${iol_schema}.bdps_ebank_property_pool.last_upd_oper_id is '最后修改操作员';
comment on column ${iol_schema}.bdps_ebank_property_pool.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdps_ebank_property_pool.int_tm is '插入时间 初始插入时间戳 yyyy-mm-dd hh:mm:ss.0';
comment on column ${iol_schema}.bdps_ebank_property_pool.misc is '备注 保留';
comment on column ${iol_schema}.bdps_ebank_property_pool.chn_src is '渠道来源 系统英文简称';
comment on column ${iol_schema}.bdps_ebank_property_pool.ebank_oper is '网银提交人';
comment on column ${iol_schema}.bdps_ebank_property_pool.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_ebank_property_pool.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_ebank_property_pool.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_ebank_property_pool.etl_timestamp is 'ETL处理时间戳';
