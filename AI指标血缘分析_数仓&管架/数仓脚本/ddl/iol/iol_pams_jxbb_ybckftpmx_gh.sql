/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ybckftpmx_gh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ybckftpmx_gh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ybckftpmx_gh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ybckftpmx_gh(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,zhhm varchar2(750) -- 账户户名
    ,zhdh varchar2(75) -- 账号代号
    ,zzh varchar2(75) -- 子账号
    ,zhbs varchar2(3) -- 账户标识
    ,kh varchar2(150) -- 卡号
    ,khh varchar2(150) -- 客户号
    ,khjgdh varchar2(75) -- 开户机构代号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,gsjgdh varchar2(75) -- 归属机构代号
    ,gsjgmc varchar2(150) -- 归属机构名称
    ,khjlgh varchar2(150) -- 客户经理工号
    ,khjlxm varchar2(150) -- 客户经理姓名
    ,fpbl number(19,5) -- 分配比例
    ,kmh varchar2(75) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,qxmc varchar2(150) -- 期限名称
    ,cph varchar2(75) -- 产品编号
    ,cpejfl varchar2(75) -- 产品二级分类
    ,cpsjfl varchar2(75) -- 产品三级分类
    ,cpsijfl varchar2(75) -- 产品四级分类
    ,cpmc varchar2(150) -- 产品中文名称
    ,zxll number(15,7) -- 账户执行利率
    ,sjll number(15,7) -- 新型存款实际利率
    ,qxrq number(22,0) -- 起息日期
    ,dqrq number(22,0) -- 到期日期
    ,xhrq number(22,0) -- 销户日期
    ,zzkzqr varchar2(30) -- 最早可支取日
    ,sfzy varchar2(15) -- 是否质押
    ,sfhx varchar2(300) -- 是否核心存款
    ,bz varchar2(45) -- 币种
    ,zhye number(25,4) -- 账户余额
    ,zhyrjye number(25,4) -- 当月日均
    ,zhnrjye number(25,4) -- 年日均
    ,ftplxzcylj number(25,4) -- 当月利息支出
    ,ftplxzcnlj number(25,4) -- 累计利息支出
    ,zyjg number(25,4) -- 转移价格
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
    ,txfpbl number(19,5) -- 条线分配比例
    ,fptx varchar2(15) -- 分配条线
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
grant select on ${iol_schema}.pams_jxbb_ybckftpmx_gh to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ybckftpmx_gh to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ybckftpmx_gh to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ybckftpmx_gh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ybckftpmx_gh is '原币存款明细-管户部分';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zhhm is '账户户名';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zhdh is '账号代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.kh is '卡号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.gsjgdh is '归属机构代号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.gsjgmc is '归属机构名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.khjlxm is '客户经理姓名';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.qxmc is '期限名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.cph is '产品编号';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.cpsjfl is '产品三级分类';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.cpmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zxll is '账户执行利率';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.sjll is '新型存款实际利率';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zzkzqr is '最早可支取日';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.sfzy is '是否质押';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.sfhx is '是否核心存款';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zhyrjye is '当月日均';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zhnrjye is '年日均';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.ftplxzcylj is '当月利息支出';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.ftplxzcnlj is '累计利息支出';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zyjg is '转移价格';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.ftpsrylj is '当月FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.ftpsrnlj is '累计FTP转移收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.ftpsyylj is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.ftpsynlj is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.ftplxzc is 'FTP利息支出';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.ftpsr is 'FTP收入';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.bzdm is '币种码值';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.fptx is '分配条线';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ybckftpmx_gh.etl_timestamp is 'ETL处理时间戳';
