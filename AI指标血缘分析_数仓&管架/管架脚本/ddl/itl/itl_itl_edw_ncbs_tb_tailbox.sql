/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncbs_tb_tailbox
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncbs_tb_tailbox
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncbs_tb_tailbox purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncbs_tb_tailbox(
    eod_voucher_equal varchar2(1) -- 日终凭证碰库标志
    ,branch varchar2(12) -- 机构编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,tailbox_property varchar2(1) -- 尾箱属性
    ,tailbox_status varchar2(1) -- 尾箱状态
    ,tailbox_type varchar2(1) -- 尾箱类型
    ,create_date date -- 创建日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,update_date date -- 更新日期
    ,assign_user_id varchar2(8) -- 分配柜员
    ,last_user_id varchar2(8) -- 上一柜员id
    ,sod_cash_equal varchar2(1) -- 日始现金碰库标识
    ,sod_voucher_equal varchar2(1) -- 日始凭证碰库标识
    ,eod_cash_equal varchar2(1) -- 日终现金碰库标志
    ,teller_bind_type varchar2(1) -- 柜员绑定关系
    ,voucher_equal_timestamp varchar2(26) -- 凭证碰库时间戳
    ,cash_equal_timestamp varchar2(26) -- 现金碰库时间戳
    ,tailbox_sub_type varchar2(1) -- 尾箱细类
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ncbs_tb_tailbox to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncbs_tb_tailbox is '尾箱基本信息表';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.eod_voucher_equal is '日终凭证碰库标志';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.branch is '机构编号';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.user_id is '交易柜员编号';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.company is '法人';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.tailbox_id is '尾箱代号';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.tailbox_property is '尾箱属性';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.tailbox_status is '尾箱状态';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.tailbox_type is '尾箱类型';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.create_date is '创建日期';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.tran_timestamp is '交易时间戳';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.update_date is '更新日期';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.assign_user_id is '分配柜员';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.last_user_id is '上一柜员id';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.sod_cash_equal is '日始现金碰库标识';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.sod_voucher_equal is '日始凭证碰库标识';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.eod_cash_equal is '日终现金碰库标志';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.teller_bind_type is '柜员绑定关系';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.voucher_equal_timestamp is '凭证碰库时间戳';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.cash_equal_timestamp is '现金碰库时间戳';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.tailbox_sub_type is '尾箱细类';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ncbs_tb_tailbox.etl_timestamp is 'ETL处理时间戳';
