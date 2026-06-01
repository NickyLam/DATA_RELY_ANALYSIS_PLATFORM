/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ybckftpmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ybckftpmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ybckftpmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ybckftpmx_recal(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,zhhm varchar2(1500) -- 账户名称
    ,zhdh varchar2(150) -- 账户代号
    ,zzh varchar2(150) -- 子账号
    ,zhbs varchar2(6) -- 账户标识
    ,kh varchar2(300) -- 卡号
    ,khh varchar2(300) -- 客户号
    ,khjgdh varchar2(150) -- 开户机构代号
    ,khjgmc varchar2(300) -- 开户机构名称
    ,gsjgdh varchar2(150) -- 归属机构代号
    ,gsjgmc varchar2(300) -- 归属机构名称
    ,khjlgh varchar2(300) -- 客户经理工号
    ,khjlxm varchar2(300) -- 客户经理名称
    ,fpbl number(19,5) -- 分配比例
    ,kmh varchar2(150) -- 科目号
    ,kmmc varchar2(300) -- 科目名称
    ,qxmc varchar2(300) -- 期限名称
    ,cph varchar2(150) -- 产品号
    ,cpejfl varchar2(150) -- 产品二级分类
    ,cpsjfl varchar2(150) -- 产品四级分类
    ,cpsijfl varchar2(150) -- 产品四级分类
    ,cpmc varchar2(300) -- 产品名称
    ,zxll number(15,7) -- 执行利率
    ,sjll number(15,7) -- 新型存款实际利率
    ,qxrq number(22) -- 起息日期
    ,dqrq number(22) -- 到期日期
    ,xhrq number(22) -- 销户日期
    ,zzkzqr varchar2(60) -- 最早可支取日
    ,sfzy varchar2(30) -- 是否质押
    ,sfhx varchar2(600) -- 是否核心
    ,bz varchar2(90) -- 币种
    ,zhye number(25,4) -- 账户余额
    ,zhyrjye number(25,4) -- 账户月日均余额
    ,zhnrjye number(25,4) -- 账户年日均余额
    ,ftplxzcylj number(25,4) -- FTP利息支出月累计
    ,ftplxzcnlj number(25,4) -- FTP利息支出年累计
    ,zyjg number(25,4) -- 转移价格
    ,ftpsrylj number(25,4) -- FTP收入月累计
    ,ftpsrnlj number(25,4) -- FTP收入年累计
    ,ftpsyylj number(25,4) -- FTP收益月累计
    ,ftpsynlj number(25,4) -- FTP收益年累计
    ,zjywsr number(25,4) -- 中间业务收入
    ,ftplxzc number(25,4) -- FTP利息支出
    ,ftpsr number(25,4) -- FTP收入
    ,ftpsy number(25,4) -- FTP收益
    ,lxkm varchar2(150) -- 利息科目
    ,lxkmmc varchar2(300) -- 利息科目名称
    ,bzdm varchar2(30) -- 币种代码
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
grant select on ${iol_schema}.pams_jxbb_ybckftpmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ybckftpmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ybckftpmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ybckftpmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ybckftpmx_recal is '原币存款明细-共管部分_重算';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zhhm is '账户名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.kh is '卡号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.gsjgdh is '归属机构代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.gsjgmc is '归属机构名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.khjlxm is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.qxmc is '期限名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.cph is '产品号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.cpsjfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zxll is '执行利率';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.sjll is '新型存款实际利率';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zzkzqr is '最早可支取日';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.sfzy is '是否质押';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.sfhx is '是否核心';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zhyrjye is '账户月日均余额';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zhnrjye is '账户年日均余额';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.ftplxzcylj is 'FTP利息支出月累计';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.ftplxzcnlj is 'FTP利息支出年累计';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zyjg is '转移价格';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.ftpsrylj is 'FTP收入月累计';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.ftpsrnlj is 'FTP收入年累计';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.ftpsynlj is 'FTP收益年累计';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.ftplxzc is 'FTP利息支出';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.ftpsr is 'FTP收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_recal.etl_timestamp is 'ETL处理时间戳';
