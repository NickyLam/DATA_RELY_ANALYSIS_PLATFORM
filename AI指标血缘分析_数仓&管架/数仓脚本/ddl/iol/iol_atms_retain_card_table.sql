/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_retain_card_table
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_retain_card_table
whenever sqlerror continue none;
drop table ${iol_schema}.atms_retain_card_table purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_retain_card_table(
    logic_id varchar2(72) -- 编号
    ,dev_no varchar2(40) -- 设备号
    ,retain_date varchar2(20) -- 吞卡日期
    ,retain_time varchar2(20) -- 吞卡时间
    ,account varchar2(50) -- 卡号
    ,reason varchar2(400) -- 原因
    ,period varchar2(20) -- 会计周期号
    ,card_stuck_org varchar2(40) -- 吞卡机构
    ,card_handle_org varchar2(40) -- 处理机构
    ,auto_flag varchar2(2) -- 自动录入标志
    ,check_op varchar2(40) -- 登记人
    ,check_date varchar2(20) -- 登记日期
    ,check_time varchar2(20) -- 登记时间
    ,op_no varchar2(40) -- 处理人
    ,op_date varchar2(20) -- 处理日期
    ,op_time varchar2(20) -- 处理时间
    ,op_address varchar2(200) -- 处理地点
    ,account_name varchar2(40) -- 客户姓名
    ,account_id varchar2(40) -- 客户证件号
    ,account_phome varchar2(15) -- 客户电话
    ,cert_type varchar2(2) -- 证件类型
    ,status varchar2(4) -- 吞卡状态
    ,account_phone varchar2(30) -- 客户电话
    ,type_flag varchar2(1) -- 新吞类型（0——吞卡，1——吞钞）
    ,card_retain_type varchar2(2) -- 吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）
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
grant select on ${iol_schema}.atms_retain_card_table to ${iml_schema};
grant select on ${iol_schema}.atms_retain_card_table to ${icl_schema};
grant select on ${iol_schema}.atms_retain_card_table to ${idl_schema};
grant select on ${iol_schema}.atms_retain_card_table to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_retain_card_table is '吞卡信息表';
comment on column ${iol_schema}.atms_retain_card_table.logic_id is '编号';
comment on column ${iol_schema}.atms_retain_card_table.dev_no is '设备号';
comment on column ${iol_schema}.atms_retain_card_table.retain_date is '吞卡日期';
comment on column ${iol_schema}.atms_retain_card_table.retain_time is '吞卡时间';
comment on column ${iol_schema}.atms_retain_card_table.account is '卡号';
comment on column ${iol_schema}.atms_retain_card_table.reason is '原因';
comment on column ${iol_schema}.atms_retain_card_table.period is '会计周期号';
comment on column ${iol_schema}.atms_retain_card_table.card_stuck_org is '吞卡机构';
comment on column ${iol_schema}.atms_retain_card_table.card_handle_org is '处理机构';
comment on column ${iol_schema}.atms_retain_card_table.auto_flag is '自动录入标志';
comment on column ${iol_schema}.atms_retain_card_table.check_op is '登记人';
comment on column ${iol_schema}.atms_retain_card_table.check_date is '登记日期';
comment on column ${iol_schema}.atms_retain_card_table.check_time is '登记时间';
comment on column ${iol_schema}.atms_retain_card_table.op_no is '处理人';
comment on column ${iol_schema}.atms_retain_card_table.op_date is '处理日期';
comment on column ${iol_schema}.atms_retain_card_table.op_time is '处理时间';
comment on column ${iol_schema}.atms_retain_card_table.op_address is '处理地点';
comment on column ${iol_schema}.atms_retain_card_table.account_name is '客户姓名';
comment on column ${iol_schema}.atms_retain_card_table.account_id is '客户证件号';
comment on column ${iol_schema}.atms_retain_card_table.account_phome is '客户电话';
comment on column ${iol_schema}.atms_retain_card_table.cert_type is '证件类型';
comment on column ${iol_schema}.atms_retain_card_table.status is '吞卡状态';
comment on column ${iol_schema}.atms_retain_card_table.account_phone is '客户电话';
comment on column ${iol_schema}.atms_retain_card_table.type_flag is '新吞类型（0——吞卡，1——吞钞）';
comment on column ${iol_schema}.atms_retain_card_table.card_retain_type is '吞卡类型，1-已吞卡到回收箱；2-已吞卡到退卡器；3-吞卡被取走（读卡器）；4-吞卡被取走（退卡器）';
comment on column ${iol_schema}.atms_retain_card_table.start_dt is '开始时间';
comment on column ${iol_schema}.atms_retain_card_table.end_dt is '结束时间';
comment on column ${iol_schema}.atms_retain_card_table.id_mark is '增删标志';
comment on column ${iol_schema}.atms_retain_card_table.etl_timestamp is 'ETL处理时间戳';
