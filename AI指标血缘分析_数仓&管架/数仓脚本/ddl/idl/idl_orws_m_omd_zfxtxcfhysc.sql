/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_omd_zfxtxcfhysc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_omd_zfxtxcfhysc
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_omd_zfxtxcfhysc purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_omd_zfxtxcfhysc(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 数据日期
    ,xh number -- 序号
    ,zfjyxh varchar2(16) -- 支付交易序号
    ,ywzl varchar2(120) -- 业务种类
    ,jyrq varchar2(8) -- 交易日期
    ,jysj varchar2(6) -- 交易时间
    ,jygy varchar2(6) -- 交易柜员
    ,jygymc varchar2(20) -- 交易柜员名称
    ,sqgy varchar2(6) -- 授权柜员
    ,sqgymc varchar2(20) -- 授权柜员名称
    ,jywd varchar2(14) -- 交易网点
    ,jywdmc varchar2(80) -- 交易网点名称
    ,jyls varchar2(20) -- 交易流水
    ,fkrzhmc varchar2(120) -- 付款人账户名称
    ,fkrzh varchar2(35) -- 付款人账号
    ,khwd varchar2(14) -- 开户网点
    ,khwdmc varchar2(80) -- 开户网点名称
    ,skrzhmc varchar2(120) -- 收款人账户名称
    ,skrzh varchar2(35) -- 收款人账号
    ,je number -- 金额
    ,jyzt varchar2(30) -- 交易状态
    ,zfxt varchar2(20) -- 支付系统
    ,ywlx varchar2(120) -- 业务类型
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
grant select on ${idl_schema}.orws_m_omd_zfxtxcfhysc to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_omd_zfxtxcfhysc is '支付系统需重复核、已删除';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.date_id is '数据日期';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.xh is '序号';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.zfjyxh is '支付交易序号';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.ywzl is '业务种类';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.jyrq is '交易日期';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.jysj is '交易时间';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.jygy is '交易柜员';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.jygymc is '交易柜员名称';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.sqgy is '授权柜员';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.sqgymc is '授权柜员名称';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.jywd is '交易网点';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.jywdmc is '交易网点名称';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.jyls is '交易流水';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.fkrzhmc is '付款人账户名称';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.fkrzh is '付款人账号';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.khwd is '开户网点';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.khwdmc is '开户网点名称';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.skrzhmc is '收款人账户名称';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.skrzh is '收款人账号';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.je is '金额';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.jyzt is '交易状态';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.zfxt is '支付系统';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.ywlx is '业务类型';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_omd_zfxtxcfhysc.etl_timestamp is 'ETL处理时间戳';
