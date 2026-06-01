/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_lsxdcptj_jg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_lsxdcptj_jg
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_lsxdcptj_jg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_lsxdcptj_jg(
    tjrq number(22,0) -- 数据日期
    ,jgkhdxdh number(22,0) -- 行员考核对象代号
    ,jgjb varchar2(8) -- 机构级别
    ,fpjs varchar2(3) -- 业绩关系
    ,cpbh varchar2(90) -- 产品编号
    ,cpmc varchar2(750) -- 产品名称
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
    ,xwdkbs varchar2(150) -- 小微贷款标识
    ,bz varchar2(150) -- 币种
    ,zdbfs varchar2(3) -- 主担保方式
    ,zhbs varchar2(150) -- 账户标识
    ,lxsr number(25,4) -- 累计利息收入（时点）
    ,fkje number(25,4) -- 放款金额(时点)
    ,zxll number(25,4) -- 执行利率
    ,jjh varchar2(150) -- 借据号
    ,khh varchar2(45) -- 客户号
    ,ffrq number(22,0) -- 发放日期
    ,bzjje number(30,4) -- 保证金金额
    ,cdje number(30,4) -- 存单金额
    ,ddckje number(30,4) -- 带动存款金额
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
grant select on ${iol_schema}.pams_jxbb_lsxdcptj_jg to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_lsxdcptj_jg to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_lsxdcptj_jg to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_lsxdcptj_jg to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_lsxdcptj_jg is '绩效报表_对公、零售产品统计_机构';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.tjrq is '数据日期';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.jgkhdxdh is '行员考核对象代号';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.jgjb is '机构级别';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.fpjs is '业绩关系';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.hyye is '余额';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.jsr is 'FTP净收入(时点)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.jsrylj is 'FTP净收入(月累计)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.jsrjlj is 'FTP净收入(季累计)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.jsrnlj is 'FTP净收入(年累计)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.lxsrylj is '累计利息（月累计）';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.lxsrjlj is '累计利息（季累计）';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.lxsrnlj is '累计利息（年累计）';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.ftpzycbnlj is '累计FTP成本';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.zdbfs is '主担保方式';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.lxsr is '累计利息收入（时点）';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.fkje is '放款金额(时点)';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.zxll is '执行利率';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.ffrq is '发放日期';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.bzjje is '保证金金额';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.cdje is '存单金额';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.ddckje is '带动存款金额';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_lsxdcptj_jg.etl_timestamp is 'ETL处理时间戳';
