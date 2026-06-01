/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_mmps_mmp_releaseloss
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_mmps_mmp_releaseloss
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_mmps_mmp_releaseloss purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_mmps_mmp_releaseloss(
    etl_dt date -- 数据日期
    ,scanseqno varchar2(30) -- 扫描流水号
    ,bizcode varchar2(6) -- 业务编码
    ,nwacno varchar2(30) -- 新卡号
    ,acctno varchar2(28) -- 账号
    ,custna varchar2(40) -- 客户姓名
    ,idtaddress varchar2(100) -- 证件地址
    ,idtdt varchar2(8) -- 证件有效期
    ,idtftp varchar2(1) -- 证件类型
    ,idtfno varchar2(20) -- 证件号码
    ,chactg varchar2(20) -- 更换类型
    ,idcheckresult varchar2(2) -- 联网核查结果
    ,pswd varchar2(20) -- 原卡密码
    ,nodeid varchar2(32) -- 节点号
    ,ch_isrpcd varchar2(1) -- 是否永久卡号换证
    ,rplsdt varchar2(8) -- 原挂失日期
    ,rplssq varchar2(20) -- 原挂失登记号
    ,vouchertype varchar2(10) -- 新凭证类型
    ,voucherno varchar2(20) -- 新凭证号码
    ,cardtype varchar2(2) -- 新卡类型
    ,cardflag varchar2(1) -- 新卡标志
    ,payway varchar2(1) -- 支取方式
    ,mobile varchar2(20) -- 联系手机号码
    ,transresult varchar2(1000) -- 交易结果
    ,uptime timestamp(6) -- 更新时间
    ,iscard varchar2(1) -- 是否有卡
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_mmps_mmp_releaseloss to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_mmps_mmp_releaseloss is '卡解挂补开交易信息表';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.scanseqno is '扫描流水号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.bizcode is '业务编码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.nwacno is '新卡号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.acctno is '账号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.custna is '客户姓名';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.idtaddress is '证件地址';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.idtdt is '证件有效期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.idtftp is '证件类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.idtfno is '证件号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.chactg is '更换类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.idcheckresult is '联网核查结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.pswd is '原卡密码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.nodeid is '节点号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.ch_isrpcd is '是否永久卡号换证';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.rplsdt is '原挂失日期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.rplssq is '原挂失登记号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.vouchertype is '新凭证类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.voucherno is '新凭证号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.cardtype is '新卡类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.cardflag is '新卡标志';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.payway is '支取方式';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.mobile is '联系手机号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.transresult is '交易结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.uptime is '更新时间';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.iscard is '是否有卡';
comment on column ${itl_schema}.itl_edw_mmps_mmp_releaseloss.etl_timestamp is 'ETL处理时间戳';