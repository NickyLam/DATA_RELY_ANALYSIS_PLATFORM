/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_khfa_khjhgl_mx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_khfa_khjhgl_mx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_khfa_khjhgl_mx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khfa_khjhgl_mx(
    mxfabh number -- 明细方案编号
    ,fabh number -- 方案编号
    ,khnf number -- 考核年份
    ,jhmc varchar2(300) -- 计划名称
    ,khdx varchar2(30) -- 考核对象
    ,lrry number -- 录入人员
    ,lrsj timestamp -- 录入时间
    ,jgkhdxdh number -- 机构考核对象代号
    ,hykhdxdh number -- 行员考核对象代号
    ,khzbdh varchar2(300) -- 考核指标代号
    ,dw varchar2(30) -- 单位
    ,dbjs number(25,4) -- 对比基数
    ,ndmbzone number(25,4) -- 年度目标值1
    ,ndmbztwo number(25,4) -- 年度目标值2
    ,ndmbzthree number(25,4) -- 年度目标值3
    ,zlddzone number(25,4) -- 总量达到值1
    ,zlddztwo number(25,4) -- 总量达到值2
    ,zlddzthree number(25,4) -- 总量达到值3
    ,janone number(25,4) -- 月度目标值_一月目标值1
    ,jantwo number(25,4) -- 月度目标值_一月目标值2
    ,janthree number(25,4) -- 月度目标值_一月目标值3
    ,febone number(25,4) -- 月度目标值_二月目标值1
    ,febtwo number(25,4) -- 月度目标值_二月目标值2
    ,febthree number(25,4) -- 月度目标值_二月目标值3
    ,marone number(25,4) -- 月度目标值_三月目标值1
    ,martwo number(25,4) -- 月度目标值_三月目标值2
    ,marthree number(25,4) -- 月度目标值_三月目标值3
    ,aprone number(25,4) -- 月度目标值_四月目标值1
    ,aprtwo number(25,4) -- 月度目标值_四月目标值2
    ,aprthree number(25,4) -- 月度目标值_四月目标值3
    ,mayone number(25,4) -- 月度目标值_五月目标值1
    ,maytwo number(25,4) -- 月度目标值_五月目标值2
    ,maythree number(25,4) -- 月度目标值_五月目标值3
    ,junone number(25,4) -- 月度目标值_六月目标值1
    ,juntwo number(25,4) -- 月度目标值_六月目标值2
    ,junthree number(25,4) -- 月度目标值_六月目标值3
    ,julone number(25,4) -- 月度目标值_七月目标值1
    ,jultwo number(25,4) -- 月度目标值_七月目标值2
    ,julthree number(25,4) -- 月度目标值_七月目标值3
    ,augone number(25,4) -- 月度目标值_八月目标值1
    ,augtwo number(25,4) -- 月度目标值_八月目标值2
    ,augthree number(25,4) -- 月度目标值_八月目标值3
    ,septone number(25,4) -- 月度目标值_九月目标值1
    ,septtwo number(25,4) -- 月度目标值_九月目标值2
    ,septthree number(25,4) -- 月度目标值_九月目标值3
    ,octone number(25,4) -- 月度目标值_十月目标值1
    ,octtwo number(25,4) -- 月度目标值_十月目标值2
    ,octthree number(25,4) -- 月度目标值_十月目标值3
    ,novone number(25,4) -- 月度目标值_十一月目标值1
    ,novtwo number(25,4) -- 月度目标值_十一月目标值2
    ,novthree number(25,4) -- 月度目标值_十一月目标值3
    ,decone number(25,4) -- 月度目标值_十二月目标值1
    ,dectwo number(25,4) -- 月度目标值_十二月目标值2
    ,decthree number(25,4) -- 月度目标值_十二月目标值3
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
grant select on ${iol_schema}.pams_khfa_khjhgl_mx to ${iml_schema};
grant select on ${iol_schema}.pams_khfa_khjhgl_mx to ${icl_schema};
grant select on ${iol_schema}.pams_khfa_khjhgl_mx to ${idl_schema};
grant select on ${iol_schema}.pams_khfa_khjhgl_mx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_khfa_khjhgl_mx is '考核方案_考核计划管理_明细';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.mxfabh is '明细方案编号';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.fabh is '方案编号';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.khnf is '考核年份';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.jhmc is '计划名称';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.khdx is '考核对象';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.lrry is '录入人员';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.lrsj is '录入时间';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.hykhdxdh is '行员考核对象代号';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.khzbdh is '考核指标代号';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.dw is '单位';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.dbjs is '对比基数';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.ndmbzone is '年度目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.ndmbztwo is '年度目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.ndmbzthree is '年度目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.zlddzone is '总量达到值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.zlddztwo is '总量达到值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.zlddzthree is '总量达到值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.janone is '月度目标值_一月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.jantwo is '月度目标值_一月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.janthree is '月度目标值_一月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.febone is '月度目标值_二月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.febtwo is '月度目标值_二月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.febthree is '月度目标值_二月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.marone is '月度目标值_三月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.martwo is '月度目标值_三月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.marthree is '月度目标值_三月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.aprone is '月度目标值_四月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.aprtwo is '月度目标值_四月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.aprthree is '月度目标值_四月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.mayone is '月度目标值_五月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.maytwo is '月度目标值_五月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.maythree is '月度目标值_五月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.junone is '月度目标值_六月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.juntwo is '月度目标值_六月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.junthree is '月度目标值_六月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.julone is '月度目标值_七月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.jultwo is '月度目标值_七月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.julthree is '月度目标值_七月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.augone is '月度目标值_八月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.augtwo is '月度目标值_八月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.augthree is '月度目标值_八月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.septone is '月度目标值_九月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.septtwo is '月度目标值_九月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.septthree is '月度目标值_九月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.octone is '月度目标值_十月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.octtwo is '月度目标值_十月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.octthree is '月度目标值_十月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.novone is '月度目标值_十一月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.novtwo is '月度目标值_十一月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.novthree is '月度目标值_十一月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.decone is '月度目标值_十二月目标值1';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.dectwo is '月度目标值_十二月目标值2';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.decthree is '月度目标值_十二月目标值3';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_khfa_khjhgl_mx.etl_timestamp is 'ETL处理时间戳';
