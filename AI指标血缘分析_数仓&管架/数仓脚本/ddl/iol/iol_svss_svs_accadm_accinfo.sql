/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol svss_svs_accadm_accinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.svss_svs_accadm_accinfo
whenever sqlerror continue none;
drop table ${iol_schema}.svss_svs_accadm_accinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svss_svs_accadm_accinfo(
    id varchar2(48) -- 账户ID
    ,main_acc_id varchar2(48) -- 主账户的ID
    ,acc_no varchar2(48) -- 账号
    ,acc_name varchar2(768) -- 账户名称
    ,open_date varchar2(15) -- 开始日期
    ,start_date varchar2(15) -- 启用日期
    ,end_date varchar2(15) -- 注销日期
    ,create_date varchar2(75) -- 建模日期（录入印鉴系统的日期）
    ,point_no varchar2(48) -- 开户网点
    ,point_name varchar2(96) -- 开户网点名
    ,link_man varchar2(96) -- 联系人
    ,address varchar2(768) -- 地址
    ,telephone varchar2(192) -- 电话
    ,if_combine number(22,0) -- 是否存在印鉴组合1:有0:没有
    ,with_draw_flag number(22,0) -- 通兑标志
    ,extend varchar2(1536) -- 扩展字段
    ,last_change_date varchar2(15) -- 上次变更日期
    ,input_op varchar2(48) -- 录入柜员
    ,check_op varchar2(48) -- 审核柜员
    ,crud_flag number(22,0) -- 账户状态
    ,acc_type number(22,0) -- 账户类型
    ,acc_category number(22,0) -- 账户种类
    ,memo varchar2(768) -- 备注
    ,sleep_flag number(22,0) -- 久悬标志
    ,main_acc_no varchar2(48) -- 主账户的账号
    ,currency_type varchar2(48) -- 币种
    ,cust_no varchar2(48) -- 客户号
    ,with_draw_org_no varchar2(768) -- 指定通兑机构
    ,upload_date varchar2(48) -- 更新日期
    ,upload_time varchar2(48) -- 更新时间
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
grant select on ${iol_schema}.svss_svs_accadm_accinfo to ${iml_schema};
grant select on ${iol_schema}.svss_svs_accadm_accinfo to ${icl_schema};
grant select on ${iol_schema}.svss_svs_accadm_accinfo to ${idl_schema};
grant select on ${iol_schema}.svss_svs_accadm_accinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.svss_svs_accadm_accinfo is '验印账户信息表';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.id is '账户ID';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.main_acc_id is '主账户的ID';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.acc_no is '账号';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.acc_name is '账户名称';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.open_date is '开始日期';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.start_date is '启用日期';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.end_date is '注销日期';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.create_date is '建模日期（录入印鉴系统的日期）';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.point_no is '开户网点';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.point_name is '开户网点名';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.link_man is '联系人';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.address is '地址';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.telephone is '电话';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.if_combine is '是否存在印鉴组合1:有0:没有';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.with_draw_flag is '通兑标志';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.extend is '扩展字段';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.last_change_date is '上次变更日期';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.input_op is '录入柜员';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.check_op is '审核柜员';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.crud_flag is '账户状态';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.acc_type is '账户类型';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.acc_category is '账户种类';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.memo is '备注';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.sleep_flag is '久悬标志';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.main_acc_no is '主账户的账号';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.currency_type is '币种';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.cust_no is '客户号';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.with_draw_org_no is '指定通兑机构';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.upload_date is '更新日期';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.upload_time is '更新时间';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.start_dt is '开始时间';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.end_dt is '结束时间';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.id_mark is '增删标志';
comment on column ${iol_schema}.svss_svs_accadm_accinfo.etl_timestamp is 'ETL处理时间戳';
