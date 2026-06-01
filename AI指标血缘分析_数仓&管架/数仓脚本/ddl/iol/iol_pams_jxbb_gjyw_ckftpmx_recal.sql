/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_gjyw_ckftpmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal(
    tjrq number -- 统计日期
    ,zhid varchar2(300) -- 账户ID
    ,khh varchar2(300) -- 客户号
    ,zhm varchar2(1500) -- 账户名
    ,zhh varchar2(300) -- 账户号
    ,zzh varchar2(300) -- 子户号
    ,fhjgdh varchar2(300) -- 分行机构号
    ,fhjgmc varchar2(300) -- 分行机构名称
    ,khjgdh varchar2(300) -- 开户机构号
    ,khjgmc varchar2(300) -- 开户机构名称
    ,ssjgdh varchar2(300) -- 所属机构号
    ,ssjgmc varchar2(300) -- 所属机构名称
    ,hydh varchar2(300) -- 客户经理工号
    ,hymc varchar2(300) -- 客户经理名称
    ,fpbl number(19,5) -- 分配比例
    ,fptx varchar2(150) -- 所属条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,qx varchar2(150) -- 存期
    ,qxmc varchar2(150) -- 存期名称
    ,cph varchar2(300) -- 产品编号
    ,cpmc varchar2(300) -- 产品中文名称
    ,qxrq number -- 起息日
    ,dqrq number -- 到期日
    ,xhrq number -- 销户日
    ,sfzy varchar2(30) -- 是否质押
    ,bzmc varchar2(90) -- 币种
    ,ckje_yb number(25,4) -- 存款金额(原币）
    ,ckje number(25,4) -- 存款金额（折合人民币）
    ,ye_yb number(25,4) -- 余额（原币）
    ,ye number(25,4) -- 余额（折合人民币）
    ,yrj number(25,4) -- 月日均
    ,jrj number(25,4) -- 季日均
    ,nrj number(25,4) -- 年日均
    ,zhzxll number(15,7) -- 账户执行利率
    ,ftpjg number(25,4) -- 存款FTP价格
    ,ftpsy number(25,4) -- 当日FTP净收益
    ,ftpsyylj number(25,4) -- 当月FTP净收益
    ,ftpsyjlj number(25,4) -- 当季FTP净收益
    ,ftpsynlj number(25,4) -- 当年FTP净收益
    ,ftpsyqlj number(25,4) -- 历史累计FTP净收益
    ,cksrlx varchar2(150) -- 存款收入类型
    ,glckywcp varchar2(150) -- 关联敞口业务产品
    ,whzhxzdm varchar2(150) -- 外汇账户性质代码
    ,whzhxzms varchar2(300) -- 外汇账户性质描述
    ,recal_dt number -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal is '绩效报表_国际业务_存款ftp明细_重算';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.zhid is '账户ID';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.zhm is '账户名';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.zhh is '账户号';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.zzh is '子户号';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.fhjgdh is '分行机构号';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.fhjgmc is '分行机构名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.khjgdh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ssjgdh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.hydh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.hymc is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.fptx is '所属条线';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.qx is '存期';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.qxmc is '存期名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.cph is '产品编号';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.cpmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.qxrq is '起息日';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.dqrq is '到期日';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.xhrq is '销户日';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.sfzy is '是否质押';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.bzmc is '币种';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ckje_yb is '存款金额(原币）';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ckje is '存款金额（折合人民币）';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ye_yb is '余额（原币）';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ye is '余额（折合人民币）';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.zhzxll is '账户执行利率';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ftpjg is '存款FTP价格';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ftpsy is '当日FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ftpsyylj is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ftpsyjlj is '当季FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ftpsynlj is '当年FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.ftpsyqlj is '历史累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.cksrlx is '存款收入类型';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.glckywcp is '关联敞口业务产品';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.whzhxzdm is '外汇账户性质代码';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.whzhxzms is '外汇账户性质描述';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal.etl_timestamp is 'ETL处理时间戳';
