/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_vpay_qr_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_vpay_qr_info
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_vpay_qr_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_vpay_qr_info(
    qr_id varchar2(128) -- 二维码id
    ,channel_id varchar2(32) -- 渠道id
    ,channel_name varchar2(200) -- 渠道名称
    ,second_channel_id varchar2(32) -- 二级渠道ID
    ,second_channel_name varchar2(200) -- 二级渠道名称
    ,salesman_id number(11,0) -- 业务员ID.关联员工表 的 EMP_ID 字段
    ,salesman_name varchar2(64) -- 业务员姓名
    ,merchant_id varchar2(32) -- 商户编号
    ,merchant_name varchar2(128) -- 商户名称
    ,use_status number(11,0) -- 状态.0-禁用  1-未绑定  2-已绑定   3-已失效
    ,bind_time timestamp -- 绑定时间
    ,qr_logo varchar2(1024) -- 二维码logo.二维码logo路径
    ,mch_logo varchar2(1024) -- 渠道logo
    ,qr_url varchar2(1024) -- 二维码访问url.二维码访问路径
    ,qr_batch_id number(11,0) -- 二维码生成批次ID
    ,update_time timestamp -- 更新时间
    ,create_time timestamp -- 创建时间
    ,accept_org_id varchar2(32) -- 受理机构id
    ,qr_no varchar2(15) -- 二维码的设备号
    ,cashier_id number(10,0) -- 收银员ID.关联员工表 的 EMP_ID 字段
    ,cashier_name varchar2(64) -- 收银员姓名
    ,fld_n1 number(10,0) -- 备用1
    ,fld_n2 number(10,0) -- 备用2
    ,fld_s1 varchar2(256) -- 字符备用1
    ,fld_s2 varchar2(256) -- 字符备用2
    ,enabled varchar2(22) -- 启用状态。1或空-启用，0-冻结
    ,business_type number(2,0) -- 业务类型 1-开票
    ,origin number(2,0) -- 来源  --1自有，2Api
    ,terminal_id varchar2(16) -- 终端编号
    ,mch_terminal_id varchar2(16) -- 商户侧终端编号
    ,terminal_address varchar2(256) -- 终端布放地址，省-市-区-详细地址
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
grant select on ${iol_schema}.amss_cms_vpay_qr_info to ${iml_schema};
grant select on ${iol_schema}.amss_cms_vpay_qr_info to ${icl_schema};
grant select on ${iol_schema}.amss_cms_vpay_qr_info to ${idl_schema};
grant select on ${iol_schema}.amss_cms_vpay_qr_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_vpay_qr_info is '固定二维码信息';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.qr_id is '二维码id';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.channel_id is '渠道id';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.channel_name is '渠道名称';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.second_channel_id is '二级渠道ID';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.second_channel_name is '二级渠道名称';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.salesman_id is '业务员ID.关联员工表 的 EMP_ID 字段';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.salesman_name is '业务员姓名';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.merchant_id is '商户编号';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.merchant_name is '商户名称';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.use_status is '状态.0-禁用  1-未绑定  2-已绑定   3-已失效';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.bind_time is '绑定时间';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.qr_logo is '二维码logo.二维码logo路径';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.mch_logo is '渠道logo';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.qr_url is '二维码访问url.二维码访问路径';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.qr_batch_id is '二维码生成批次ID';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.update_time is '更新时间';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.create_time is '创建时间';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.accept_org_id is '受理机构id';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.qr_no is '二维码的设备号';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.cashier_id is '收银员ID.关联员工表 的 EMP_ID 字段';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.cashier_name is '收银员姓名';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.fld_n1 is '备用1';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.fld_n2 is '备用2';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.fld_s1 is '字符备用1';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.fld_s2 is '字符备用2';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.enabled is '启用状态。1或空-启用，0-冻结';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.business_type is '业务类型 1-开票';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.origin is '来源  --1自有，2Api';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.terminal_id is '终端编号';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.mch_terminal_id is '商户侧终端编号';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.terminal_address is '终端布放地址，省-市-区-详细地址';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_vpay_qr_info.etl_timestamp is 'ETL处理时间戳';
