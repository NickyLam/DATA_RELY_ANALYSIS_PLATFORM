/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_yy_cbzjkb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_yy_cbzjkb
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_yy_cbzjkb purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_yy_cbzjkb(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(20) -- 业务日期
    ,brchno varchar2(20) -- 机构号
    ,brchna varchar2(100) -- 机构名称
    ,nums number -- 笔数
    ,usertp varchar2(30) -- 柜员类型
    ,trantp varchar2(20) -- 业务类型
    ,cz_dt varchar2(200) -- 冲正日期
    ,prcscd varchar2(16) -- 交易码
    ,jyna varchar2(100) -- 交易名称
    ,cz_item varchar2(56) -- 冲正项目
    ,cz_amntcd varchar2(16) -- 冲账借贷方向
    ,cz_acctno varchar2(40) -- 冲正交易账号
    ,cz_acctna varchar2(110) -- 冲正户名
    ,cz_tranam number -- 冲正金额
    ,cz_transq varchar2(20) -- 冲正交易流水号
    ,cz_bz varchar2(100) -- 冲账备注
    ,gyh varchar2(20) -- 操作柜员
    ,gy_na varchar2(20) -- 操作员名称
    ,sqgyh varchar2(20) -- 授权柜员
    ,sqgy_na varchar2(20) -- 授权柜员名称
    ,sttsdt varchar2(20) -- 原交易日期
    ,st_amntcd varchar2(20) -- 原交易借贷方向
    ,st_acctno varchar2(40) -- 原交易账号
    ,st_acctna varchar2(100) -- 原交易户名
    ,st_tranam number -- 原交易金额
    ,st_transq varchar2(20) -- 原交易流水
    ,st_gyh varchar2(20) -- 原交易柜员号
    ,st_gyna varchar2(20) -- 原交易柜员名称
    ,st_sqgyh varchar2(20) -- 原授权柜员号
    ,st_sqgyna varchar2(20) -- 原授权柜员名称
    ,bz_tsdt varchar2(20) -- 补账日期及时间
    ,bz_amntcd varchar2(20) -- 补账借贷方向
    ,bz_acctno varchar2(40) -- 补账交易账号
    ,bz_acctna varchar2(100) -- 补账户名
    ,bz_tranam number -- 金额
    ,bz_transq varchar2(20) -- 补账交易流水号
    ,bz_gyh varchar2(20) -- 补账交易柜员号
    ,bz_gyna varchar2(20) -- 补账交易柜员名称
    ,bz_sqgyh varchar2(20) -- 补账授权柜员号
    ,bz_sqgyna varchar2(20) -- 补账授权柜员名称
    ,bz_bz varchar2(100) -- 补账备注
    ,jy_qd varchar2(20) -- 交易渠道
    ,gz_clqk varchar2(20) -- 跟踪处理情况
    ,bz varchar2(2) -- 备注：1冲账 2 补账
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.orws_m_yy_cbzjkb to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_yy_cbzjkb is '冲补账监控统计表';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.date_id is '业务日期';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.brchno is '机构号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.brchna is '机构名称';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.nums is '笔数';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.usertp is '柜员类型';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.trantp is '业务类型';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.cz_dt is '冲正日期';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.prcscd is '交易码';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.jyna is '交易名称';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.cz_item is '冲正项目';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.cz_amntcd is '冲账借贷方向';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.cz_acctno is '冲正交易账号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.cz_acctna is '冲正户名';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.cz_tranam is '冲正金额';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.cz_transq is '冲正交易流水号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.cz_bz is '冲账备注';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.gyh is '操作柜员';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.gy_na is '操作员名称';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.sqgyh is '授权柜员';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.sqgy_na is '授权柜员名称';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.sttsdt is '原交易日期';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.st_amntcd is '原交易借贷方向';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.st_acctno is '原交易账号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.st_acctna is '原交易户名';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.st_tranam is '原交易金额';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.st_transq is '原交易流水';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.st_gyh is '原交易柜员号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.st_gyna is '原交易柜员名称';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.st_sqgyh is '原授权柜员号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.st_sqgyna is '原授权柜员名称';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_tsdt is '补账日期及时间';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_amntcd is '补账借贷方向';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_acctno is '补账交易账号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_acctna is '补账户名';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_tranam is '金额';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_transq is '补账交易流水号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_gyh is '补账交易柜员号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_gyna is '补账交易柜员名称';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_sqgyh is '补账授权柜员号';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_sqgyna is '补账授权柜员名称';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz_bz is '补账备注';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.jy_qd is '交易渠道';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.gz_clqk is '跟踪处理情况';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.bz is '备注：1冲账 2 补账';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_yy_cbzjkb.etl_timestamp is 'ETL处理时间戳';
