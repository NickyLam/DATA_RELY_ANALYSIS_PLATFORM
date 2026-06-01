/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_jxbb_ckftpmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal(
    etl_dt date
    ,tjrq number(22)
    ,jxdxdh number(22)
    ,khdxdh number(22)
    ,zhhm varchar2(1500)
    ,zhdh varchar2(150)
    ,zzh varchar2(150)
    ,zhbs varchar2(6)
    ,kh varchar2(300)
    ,khh varchar2(300)
    ,khjgdh varchar2(150)
    ,khjgmc varchar2(300)
    ,gsjgdh varchar2(150)
    ,gsjgmc varchar2(300)
    ,khjlgh varchar2(300)
    ,khjlxm varchar2(300)
    ,fpbl number(19,5)
    ,kmh varchar2(150)
    ,kmmc varchar2(300)
    ,qxmc varchar2(300)
    ,cph varchar2(150)
    ,cpejfl varchar2(150)
    ,cpsjfl varchar2(150)
    ,cpsijfl varchar2(150)
    ,cpmc varchar2(300)
    ,zxll number(15,7)
    ,sjll number(15,7)
    ,qxrq number(22)
    ,dqrq number(22)
    ,xhrq number(22)
    ,zzkzqr varchar2(60)
    ,sfzy varchar2(30)
    ,sfhx varchar2(600)
    ,bz varchar2(90)
    ,zhye number(25,4)
    ,zhyrjye number(25,4)
    ,zhnrjye number(25,4)
    ,ftplxzcylj number(25,4)
    ,ftplxzcnlj number(25,4)
    ,zyjg number(25,4)
    ,ftpsrylj number(25,4)
    ,ftpsrnlj number(25,4)
    ,ftpsyylj number(25,4)
    ,ftpsynlj number(25,4)
    ,zjywsr number(25,4)
    ,ftplxzc number(25,4)
    ,ftpsr number(25,4)
    ,ftpsy number(25,4)
    ,lxkm varchar2(150)
    ,lxkmmc varchar2(300)
    ,bzdm varchar2(30)
    ,fptx varchar2(30)
    ,txfpbl number(19,5)
    ,qx varchar2(30)
    ,ydshrq number(22)
    ,sjssjgdh varchar2(30)
    ,zhjrjye number(25,4)
    ,recal_dt number(22)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal is '客户存款ftp结果表_重算';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.jxdxdh is '绩效对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.khdxdh is '考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zhhm is '账户名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zhdh is '账户代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zzh is '子账号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zhbs is '账户标识';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.kh is '卡号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.khh is '客户号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.khjgdh is '开户机构代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.khjgmc is '开户机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.gsjgdh is '归属机构代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.gsjgmc is '归属机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.khjlgh is '客户经理工号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.khjlxm is '客户经理名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.fpbl is '分配比例';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.kmh is '科目号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.kmmc is '科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.qxmc is '期限名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.cph is '产品号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.cpejfl is '产品二级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.cpsjfl is '产品四级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.cpsijfl is '产品四级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.cpmc is '产品名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zxll is '执行利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.sjll is '新型存款实际利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.qxrq is '起息日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.dqrq is '到期日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.xhrq is '销户日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zzkzqr is '最早可支取日';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.sfzy is '是否质押';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.sfhx is '是否核心';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.bz is '币种';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zhye is '账户余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zhyrjye is '账户月日均余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zhnrjye is '账户年日均余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ftplxzcylj is 'ftp利息支出月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ftplxzcnlj is 'ftp利息支出年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zyjg is '转移价格';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ftpsrylj is 'ftp收入月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ftpsrnlj is 'ftp收入年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ftpsyylj is 'ftp收益月累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ftpsynlj is 'ftp收益年累计';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zjywsr is '中间业务收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ftplxzc is 'ftp利息支出';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ftpsr is 'ftp收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ftpsy is 'ftp收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.lxkm is '利息科目';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.lxkmmc is '利息科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.bzdm is '币种代码';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.fptx is '分配条线';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.txfpbl is '条线分配比例';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.qx is '账户期限代码';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.ydshrq is '大额存单约定赎回日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.sjssjgdh is '实际所属机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.zhjrjye is '账户季日均余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_ckftpmx_recal.recal_dt is '重算日期';
