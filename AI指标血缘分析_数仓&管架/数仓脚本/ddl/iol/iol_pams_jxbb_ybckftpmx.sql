/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ybckftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ybckftpmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ybckftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ybckftpmx(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,zhhm varchar2(750) -- 账户户名
    ,zhdh varchar2(75) -- 账户代号
    ,zzh varchar2(75) -- 子账户
    ,zhbs varchar2(3) -- 账户标识
    ,kh varchar2(150) -- 卡号
    ,khh varchar2(150) -- 客户号
    ,khjgdh varchar2(75) -- 开户机构代号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,gsjgdh varchar2(75) -- 归属机构代号
    ,gsjgmc varchar2(150) -- 归属机构名称
    ,khjlgh varchar2(150) -- 客户经理工号
    ,khjlxm varchar2(150) -- 客户经理名称
    ,fpbl number(19,5) -- 分配比例
    ,kmh varchar2(75) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,qxmc varchar2(150) -- 存期
    ,cph varchar2(75) -- 产品编号
    ,cpejfl varchar2(75) -- 产品二级分类
    ,cpsjfl varchar2(75) -- 产品三级分类
    ,cpsijfl varchar2(75) -- 产品四级分类
    ,cpmc varchar2(150) -- 产品中文名称
    ,zxll number(15,7) -- 账户执行利率
    ,sjll number(15,7) -- 新型存款实际利率
    ,qxrq number(22,0) -- 起息日
    ,dqrq number(22,0) -- 到期日
    ,xhrq number(22,0) -- 销户日
    ,zzkzqr varchar2(30) -- 最早可支取日
    ,sfzy varchar2(15) -- 是否质押
    ,sfhx varchar2(300) -- 是否核心存款
    ,bz varchar2(45) -- 币种
    ,zhye number(25,4) -- 余额
    ,zhyrjye number(25,4) -- 当月日均
    ,zhnrjye number(25,4) -- 年日均
    ,ftplxzcylj number(25,4) -- 当月利息支出
    ,ftplxzcnlj number(25,4) -- 累计利息支出
    ,zyjg number(25,4) -- FTP价格
    ,ftpsrylj number(25,4) -- 当月FTP转移收入
    ,ftpsrnlj number(25,4) -- 累计FTP转移收入
    ,ftpsyylj number(25,4) -- 当月FTP净收益
    ,ftpsynlj number(25,4) -- 累计FTP净收益
    ,zjywsr number(25,4) -- 中间业务收入
    ,ftplxzc number(25,4) -- FTP利息支出
    ,ftpsr number(25,4) -- FTP收入
    ,ftpsy number(25,4) -- FTP收益
    ,lxkm varchar2(75) -- 利息科目
    ,lxkmmc varchar2(150) -- 利息科目名称
    ,bzdm varchar2(15) -- 币种码值
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
grant select on ${iol_schema}.pams_jxbb_ybckftpmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ybckftpmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ybckftpmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ybckftpmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ybckftpmx is '原币存款明细-共管部分';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zhhm is '账户户名';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zzh is '子账户';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.kh is '卡号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.gsjgdh is '归属机构代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.gsjgmc is '归属机构名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.khjlxm is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.qxmc is '存期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.cph is '产品编号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.cpsjfl is '产品三级分类';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.cpmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zxll is '账户执行利率';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.sjll is '新型存款实际利率';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.qxrq is '起息日';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.dqrq is '到期日';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.xhrq is '销户日';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zzkzqr is '最早可支取日';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.sfzy is '是否质押';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.sfhx is '是否核心存款';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zhye is '余额';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zhyrjye is '当月日均';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zhnrjye is '年日均';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.ftplxzcylj is '当月利息支出';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.ftplxzcnlj is '累计利息支出';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zyjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.ftpsrylj is '当月FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.ftpsrnlj is '累计FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.ftpsyylj is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.ftpsynlj is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.ftplxzc is 'FTP利息支出';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.ftpsr is 'FTP收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.bzdm is '币种码值';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx.etl_timestamp is 'ETL处理时间戳';
