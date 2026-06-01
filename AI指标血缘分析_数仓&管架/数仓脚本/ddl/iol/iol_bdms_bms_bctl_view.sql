/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_bctl_view
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_bctl_view
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_bctl_view purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_bctl_view(
    id varchar2(45) -- id
    ,br_no varchar2(18) -- 外部机构号
    ,br_name varchar2(300) -- 机构名称
    ,bank_no varchar2(18) -- 联行行号
    ,br_class varchar2(3) -- 机构级别 1-总行2-分行 3-个贷中心 5-支行
    ,br_attr varchar2(2) -- 1-财务机构
    ,br_manager_id varchar2(45) -- 总行id
    ,br_up_id varchar2(45) -- 归属上级行999分行的上级行是9999 其他的分行级别的上级行是999分行
    ,tele_no varchar2(45) -- 联系电话
    ,address varchar2(600) -- 地址
    ,post_no varchar2(9) -- 邮编
    ,ip varchar2(30) -- ip
    ,finance_code varchar2(21) -- 预留字段
    ,status varchar2(2) -- 是否生效：0-无效1-有效
    ,update_userid varchar2(48) -- 最后修改人
    ,update_date timestamp -- 最后更新时间
    ,is_del number(22,0) -- 是否已删除 0-未删除，1-已删除
    ,create_userid varchar2(48) -- 创建人
    ,create_date timestamp -- 创建时间
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
grant select on ${iol_schema}.bdms_bms_bctl_view to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_bctl_view to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_bctl_view to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_bctl_view to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_bctl_view is '机构表';
comment on column ${iol_schema}.bdms_bms_bctl_view.id is 'id';
comment on column ${iol_schema}.bdms_bms_bctl_view.br_no is '外部机构号';
comment on column ${iol_schema}.bdms_bms_bctl_view.br_name is '机构名称';
comment on column ${iol_schema}.bdms_bms_bctl_view.bank_no is '联行行号';
comment on column ${iol_schema}.bdms_bms_bctl_view.br_class is '机构级别 1-总行2-分行 3-个贷中心 5-支行';
comment on column ${iol_schema}.bdms_bms_bctl_view.br_attr is '1-财务机构';
comment on column ${iol_schema}.bdms_bms_bctl_view.br_manager_id is '总行id';
comment on column ${iol_schema}.bdms_bms_bctl_view.br_up_id is '归属上级行999分行的上级行是9999 其他的分行级别的上级行是999分行';
comment on column ${iol_schema}.bdms_bms_bctl_view.tele_no is '联系电话';
comment on column ${iol_schema}.bdms_bms_bctl_view.address is '地址';
comment on column ${iol_schema}.bdms_bms_bctl_view.post_no is '邮编';
comment on column ${iol_schema}.bdms_bms_bctl_view.ip is 'ip';
comment on column ${iol_schema}.bdms_bms_bctl_view.finance_code is '预留字段';
comment on column ${iol_schema}.bdms_bms_bctl_view.status is '是否生效：0-无效1-有效';
comment on column ${iol_schema}.bdms_bms_bctl_view.update_userid is '最后修改人';
comment on column ${iol_schema}.bdms_bms_bctl_view.update_date is '最后更新时间';
comment on column ${iol_schema}.bdms_bms_bctl_view.is_del is '是否已删除 0-未删除，1-已删除';
comment on column ${iol_schema}.bdms_bms_bctl_view.create_userid is '创建人';
comment on column ${iol_schema}.bdms_bms_bctl_view.create_date is '创建时间';
comment on column ${iol_schema}.bdms_bms_bctl_view.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_bctl_view.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_bctl_view.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_bctl_view.etl_timestamp is 'ETL处理时间戳';
