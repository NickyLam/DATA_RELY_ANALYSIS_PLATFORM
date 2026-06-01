/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_lsxdcptjwbzmy_jg_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal(
    tjrq number(22) -- 数据日期
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,jgjb varchar2(15) -- 机构级别
    ,fpjs varchar2(6) -- 分配角色：1-共管，2-管户
    ,cpbh varchar2(180) -- 产品编号
    ,cpmc varchar2(1500) -- 产品名称
    ,hyye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,jrj number(25,4) -- 季日均
    ,nrj number(25,4) -- 年日均
    ,jsr number(25,4) -- FTP净收入(时点)
    ,jsrylj number(25,4) -- FTP净收入(月累计)
    ,jsrjlj number(25,4) -- FTP净收入(季累计)
    ,jsrnlj number(25,4) -- FTP净收入(年累计)
    ,lxsrylj number(25,4) -- 累计利息（月累计）
    ,lxsrjlj number(25,4) -- 累计利息（季累计）
    ,lxsrnlj number(25,4) -- 累计利息（年累计）
    ,ftpzycbnlj number(25,4) -- 累计FTP成本
    ,xwdkbs varchar2(300) -- 小微贷款标识
    ,bz varchar2(300) -- 币种
    ,zdbfs varchar2(6) -- 主担保方式
    ,zhbs varchar2(300) -- 账户标识
    ,lxsr number(25,4) -- 累计利息收入（时点）
    ,fkje number(25,4) -- 放款金额(时点)
    ,zxll number(25,4) -- 执行利率
    ,jjh varchar2(300) -- 借据号
    ,khh varchar2(90) -- 客户号
    ,ffrq number(22) -- 发放日期
    ,recal_dt number(22) -- 重算日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal is '绩效报表_对公外币折美元产品统计_机构_重算';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.tjrq is '数据日期';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.jgjb is '机构级别';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.fpjs is '分配角色：1-共管，2-管户';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.hyye is '余额';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.jsr is 'FTP净收入(时点)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.jsrylj is 'FTP净收入(月累计)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.jsrjlj is 'FTP净收入(季累计)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.jsrnlj is 'FTP净收入(年累计)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.lxsrylj is '累计利息（月累计）';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.lxsrjlj is '累计利息（季累计）';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.lxsrnlj is '累计利息（年累计）';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.ftpzycbnlj is '累计FTP成本';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.zdbfs is '主担保方式';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.lxsr is '累计利息收入（时点）';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.fkje is '放款金额(时点)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.zxll is '执行利率';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.ffrq is '发放日期';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal.etl_timestamp is 'ETL处理时间戳';
