/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_dklrmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_dklrmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_dklrmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_dklrmx_recal(
    tjrq number(22) -- 统计日期
    ,khdxdh number(22) -- 考核对象代号
    ,jxdxdh number(22) -- 绩效对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,kmh varchar2(60) -- 科目号
    ,cph varchar2(60) -- 产品号
    ,ywpz varchar2(60) -- 业务品种
    ,fpjs varchar2(6) -- 分配角色
    ,zhdh varchar2(120) -- 账户代号
    ,zzh varchar2(300) -- 子账号
    ,zhhm varchar2(300) -- 账户名称
    ,khh varchar2(90) -- 客户号
    ,jgdh varchar2(30) -- 机构代号
    ,qx varchar2(12) -- 期限
    ,zhbs varchar2(3) -- 账户标识
    ,bz varchar2(9) -- 币种
    ,nll number(15,7) -- 年利率
    ,zyjg number(15,7) -- 转移价格
    ,ftplc number(15,7) -- FTP利差
    ,zlbl number(19,5) -- 认领比例
    ,zhye number(25,4) -- 账户余额
    ,hyye number(25,4) -- 行员余额
    ,hyylj number(25,4) -- 行员月累计
    ,hyjlj number(25,4) -- 行员季累计
    ,hybnlj number(25,4) -- 行员半年累计
    ,hynlj number(25,4) -- 行员年累计
    ,wjfl varchar2(3) -- 五级分类
    ,khdkje number(25,4) -- 客户贷款金额
    ,ftpzycb number(25,4) -- FTP转移成本
    ,ftpzycbylj number(25,4) -- FTP转移成本月累计
    ,ftpzycbjlj number(25,4) -- FTP转移成本季累计
    ,ftpzycbbnlj number(25,4) -- FTP转移成本半年累计
    ,ftpzycbnlj number(25,4) -- FTP转移成本年累计
    ,ftplxsr number(25,4) -- FTP利息收入
    ,ftplxsrylj number(25,4) -- FTP利息收入月累计
    ,ftplxsrjlj number(25,4) -- FTP利息收入季累计
    ,ftplxsrbnlj number(25,4) -- FTP利息收入半年累计
    ,ftplxsrnlj number(25,4) -- FTP利息收入年累计
    ,ftpsy number(25,4) -- FTP收益
    ,ftpsyylj number(25,4) -- FTP收益月累计
    ,ftpsyjlj number(25,4) -- FTP收益季累计
    ,ftpsybnlj number(25,4) -- FTP收益半年累计
    ,ftpsynlj number(25,4) -- FTP收益年累计
    ,hxbz varchar2(3) -- 核销标志
    ,xwdkbs varchar2(3) -- 小微贷款标识
    ,zxzdkztdm varchar2(90) -- 支小再贷款状态代码
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
grant select on ${iol_schema}.pams_nbzz_dklrmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_dklrmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_dklrmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_dklrmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_dklrmx_recal is '贷款利润明细账_重算';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.cph is '产品号';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ywpz is '业务品种';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.zhdh is '账户代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.zzh is '子账号';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.zhhm is '账户名称';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.qx is '期限';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.zhbs is '账户标识';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.nll is '年利率';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.zyjg is '转移价格';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftplc is 'FTP利差';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.hyye is '行员余额';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.hyylj is '行员月累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.hyjlj is '行员季累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.hybnlj is '行员半年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.hynlj is '行员年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.wjfl is '五级分类';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.khdkje is '客户贷款金额';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpzycb is 'FTP转移成本';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpzycbylj is 'FTP转移成本月累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpzycbjlj is 'FTP转移成本季累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpzycbbnlj is 'FTP转移成本半年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpzycbnlj is 'FTP转移成本年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftplxsr is 'FTP利息收入';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftplxsrylj is 'FTP利息收入月累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftplxsrjlj is 'FTP利息收入季累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftplxsrbnlj is 'FTP利息收入半年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftplxsrnlj is 'FTP利息收入年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpsyjlj is 'FTP收益季累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpsybnlj is 'FTP收益半年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.ftpsynlj is 'FTP收益年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.hxbz is '核销标志';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.zxzdkztdm is '支小再贷款状态代码';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_dklrmx_recal.etl_timestamp is 'ETL处理时间戳';
