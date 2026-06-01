/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_work_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_party_work_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_work_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_work_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_work_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_party_work_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_party_work_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_work_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,tel_num -- 电话号码
    ,work_unit_addr -- 工作单位地址
    ,work_unit_name -- 工作单位名称
    ,work_unit_char_cd -- 工作单位性质代码
    ,work_mon_inco -- 工作月收入
    ,anl_inco -- 年收入
    ,employ_year_cnt -- 雇佣年数
    ,emply_status_cd -- 雇用状态代码
    ,dimission_dt -- 离职日期
    ,empyt_dt -- 入职日期
    ,zip_cd -- 邮政编码
    ,title_cd -- 职称代码
    ,post_cd -- 职务代码
    ,career_cd -- 职业代码
    ,corp_work_start_year -- 本单位工作起始年份
    ,corp_iac_que_rest_cd -- 单位工商查询结果代码
    ,corp_rgst_dt -- 单位注册日期
    ,corp_rgst_cap_gold -- 单位注册资本金
    ,work_unit_sspf_flg -- 工作单位与社保公积金一致标志
    ,work_record_cd -- 工作履历代码
    ,work_char_cd -- 工作性质代码
    ,employ_type_cd -- 雇佣类型代码
    ,indus_risk_cate_cd -- 行业风险类别代码
    ,trading_corp_flg -- 贸易型企业标志
    ,curr_indus_obtain_emply_years -- 目前行业从业年限
    ,serving_years -- 任职年限
    ,local_dept -- 所在部门
    ,other_career -- 其他职业
    ,now_corp_work_years -- 现单位工作年限
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_work_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_party_work_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_work_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_party_work_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_work_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_ind_info-
insert into ${iml_schema}.pty_party_work_info_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,tel_num -- 电话号码
    ,work_unit_addr -- 工作单位地址
    ,work_unit_name -- 工作单位名称
    ,work_unit_char_cd -- 工作单位性质代码
    ,work_mon_inco -- 工作月收入
    ,anl_inco -- 年收入
    ,employ_year_cnt -- 雇佣年数
    ,emply_status_cd -- 雇用状态代码
    ,dimission_dt -- 离职日期
    ,empyt_dt -- 入职日期
    ,zip_cd -- 邮政编码
    ,title_cd -- 职称代码
    ,post_cd -- 职务代码
    ,career_cd -- 职业代码
    ,corp_work_start_year -- 本单位工作起始年份
    ,corp_iac_que_rest_cd -- 单位工商查询结果代码
    ,corp_rgst_dt -- 单位注册日期
    ,corp_rgst_cap_gold -- 单位注册资本金
    ,work_unit_sspf_flg -- 工作单位与社保公积金一致标志
    ,work_record_cd -- 工作履历代码
    ,work_char_cd -- 工作性质代码
    ,employ_type_cd -- 雇佣类型代码
    ,indus_risk_cate_cd -- 行业风险类别代码
    ,trading_corp_flg -- 贸易型企业标志
    ,curr_indus_obtain_emply_years -- 目前行业从业年限
    ,serving_years -- 任职年限
    ,local_dept -- 所在部门
    ,other_career -- 其他职业
    ,now_corp_work_years -- 现单位工作年限
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUSTOMERID -- 当事人编号
    ,'9999' -- 法人编号
    ,'ICMS' -- 源系统代码
    ,nvl(trim(P1.INDUSTRY),'-') -- 单位所属行业类型代码
    ,P1.UNITPHONE -- 电话号码
    ,P1.UNITADDRESS -- 工作单位地址
    ,P1.WORKNAME -- 工作单位名称
    ,P1.UNITKIND -- 工作单位性质代码
    ,0 -- 工作月收入
    ,0 -- 年收入
    ,P1.CURRENTWORKYEARS -- 雇佣年数
    ,'-' -- 雇用状态代码
    ,${iml_schema}.dateformat_max2(NULL) -- 离职日期
    ,${iml_schema}.dateformat_min(NULL) -- 入职日期
    ,P1.UNITPOSTCODE -- 邮政编码
    ,NVL(TRIM(P1.TITLE),'99') -- 职称代码
    ,NVL(TRIM(P1.HEADSHIP),'9') -- 职务代码
    ,nvl(trim(P1.OCCUPATION),'-') -- 职业代码
  	,P1.WORKBEGINDATE -- 本单位工作起始年份
    ,' ' -- 单位工商查询结果代码
    ,${iml_schema}.dateformat_min(NULL) -- 单位注册日期
    ,0.0 -- 单位注册资本金
    ,'-' -- 工作单位与社保公积金一致标志
    ,' ' -- 工作履历代码
    ,' ' -- 工作性质代码
    ,' ' -- 雇佣类型代码
    ,' ' -- 行业风险类别代码
    ,' ' -- 贸易型企业标志
    ,0.0 -- 目前行业从业年限
    ,P1.CURRENTWORKYEARS -- 任职年限
    ,' ' -- 所在部门
    ,' ' -- 其他职业
    ,P1.CURRENTWORKYEARS -- 现单位工作年限
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ind_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ind_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_work_info_h_icmsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,sorc_sys_cd
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_work_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,tel_num -- 电话号码
    ,work_unit_addr -- 工作单位地址
    ,work_unit_name -- 工作单位名称
    ,work_unit_char_cd -- 工作单位性质代码
    ,work_mon_inco -- 工作月收入
    ,anl_inco -- 年收入
    ,employ_year_cnt -- 雇佣年数
    ,emply_status_cd -- 雇用状态代码
    ,dimission_dt -- 离职日期
    ,empyt_dt -- 入职日期
    ,zip_cd -- 邮政编码
    ,title_cd -- 职称代码
    ,post_cd -- 职务代码
    ,career_cd -- 职业代码
    ,corp_work_start_year -- 本单位工作起始年份
    ,corp_iac_que_rest_cd -- 单位工商查询结果代码
    ,corp_rgst_dt -- 单位注册日期
    ,corp_rgst_cap_gold -- 单位注册资本金
    ,work_unit_sspf_flg -- 工作单位与社保公积金一致标志
    ,work_record_cd -- 工作履历代码
    ,work_char_cd -- 工作性质代码
    ,employ_type_cd -- 雇佣类型代码
    ,indus_risk_cate_cd -- 行业风险类别代码
    ,trading_corp_flg -- 贸易型企业标志
    ,curr_indus_obtain_emply_years -- 目前行业从业年限
    ,serving_years -- 任职年限
    ,local_dept -- 所在部门
    ,other_career -- 其他职业
    ,now_corp_work_years -- 现单位工作年限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_work_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,tel_num -- 电话号码
    ,work_unit_addr -- 工作单位地址
    ,work_unit_name -- 工作单位名称
    ,work_unit_char_cd -- 工作单位性质代码
    ,work_mon_inco -- 工作月收入
    ,anl_inco -- 年收入
    ,employ_year_cnt -- 雇佣年数
    ,emply_status_cd -- 雇用状态代码
    ,dimission_dt -- 离职日期
    ,empyt_dt -- 入职日期
    ,zip_cd -- 邮政编码
    ,title_cd -- 职称代码
    ,post_cd -- 职务代码
    ,career_cd -- 职业代码
    ,corp_work_start_year -- 本单位工作起始年份
    ,corp_iac_que_rest_cd -- 单位工商查询结果代码
    ,corp_rgst_dt -- 单位注册日期
    ,corp_rgst_cap_gold -- 单位注册资本金
    ,work_unit_sspf_flg -- 工作单位与社保公积金一致标志
    ,work_record_cd -- 工作履历代码
    ,work_char_cd -- 工作性质代码
    ,employ_type_cd -- 雇佣类型代码
    ,indus_risk_cate_cd -- 行业风险类别代码
    ,trading_corp_flg -- 贸易型企业标志
    ,curr_indus_obtain_emply_years -- 目前行业从业年限
    ,serving_years -- 任职年限
    ,local_dept -- 所在部门
    ,other_career -- 其他职业
    ,now_corp_work_years -- 现单位工作年限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.corp_bl_induty_type_cd, o.corp_bl_induty_type_cd) as corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.work_unit_addr, o.work_unit_addr) as work_unit_addr -- 工作单位地址
    ,nvl(n.work_unit_name, o.work_unit_name) as work_unit_name -- 工作单位名称
    ,nvl(n.work_unit_char_cd, o.work_unit_char_cd) as work_unit_char_cd -- 工作单位性质代码
    ,nvl(n.work_mon_inco, o.work_mon_inco) as work_mon_inco -- 工作月收入
    ,nvl(n.anl_inco, o.anl_inco) as anl_inco -- 年收入
    ,nvl(n.employ_year_cnt, o.employ_year_cnt) as employ_year_cnt -- 雇佣年数
    ,nvl(n.emply_status_cd, o.emply_status_cd) as emply_status_cd -- 雇用状态代码
    ,nvl(n.dimission_dt, o.dimission_dt) as dimission_dt -- 离职日期
    ,nvl(n.empyt_dt, o.empyt_dt) as empyt_dt -- 入职日期
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.title_cd, o.title_cd) as title_cd -- 职称代码
    ,nvl(n.post_cd, o.post_cd) as post_cd -- 职务代码
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业代码
    ,nvl(n.corp_work_start_year, o.corp_work_start_year) as corp_work_start_year -- 本单位工作起始年份
    ,nvl(n.corp_iac_que_rest_cd, o.corp_iac_que_rest_cd) as corp_iac_que_rest_cd -- 单位工商查询结果代码
    ,nvl(n.corp_rgst_dt, o.corp_rgst_dt) as corp_rgst_dt -- 单位注册日期
    ,nvl(n.corp_rgst_cap_gold, o.corp_rgst_cap_gold) as corp_rgst_cap_gold -- 单位注册资本金
    ,nvl(n.work_unit_sspf_flg, o.work_unit_sspf_flg) as work_unit_sspf_flg -- 工作单位与社保公积金一致标志
    ,nvl(n.work_record_cd, o.work_record_cd) as work_record_cd -- 工作履历代码
    ,nvl(n.work_char_cd, o.work_char_cd) as work_char_cd -- 工作性质代码
    ,nvl(n.employ_type_cd, o.employ_type_cd) as employ_type_cd -- 雇佣类型代码
    ,nvl(n.indus_risk_cate_cd, o.indus_risk_cate_cd) as indus_risk_cate_cd -- 行业风险类别代码
    ,nvl(n.trading_corp_flg, o.trading_corp_flg) as trading_corp_flg -- 贸易型企业标志
    ,nvl(n.curr_indus_obtain_emply_years, o.curr_indus_obtain_emply_years) as curr_indus_obtain_emply_years -- 目前行业从业年限
    ,nvl(n.serving_years, o.serving_years) as serving_years -- 任职年限
    ,nvl(n.local_dept, o.local_dept) as local_dept -- 所在部门
    ,nvl(n.other_career, o.other_career) as other_career -- 其他职业
    ,nvl(n.now_corp_work_years, o.now_corp_work_years) as now_corp_work_years -- 现单位工作年限
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_work_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_party_work_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
where (
        o.party_id is null
        and o.lp_id is null
        and o.sorc_sys_cd is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.sorc_sys_cd is null
    )
    or (
        o.corp_bl_induty_type_cd <> n.corp_bl_induty_type_cd
        or o.tel_num <> n.tel_num
        or o.work_unit_addr <> n.work_unit_addr
        or o.work_unit_name <> n.work_unit_name
        or o.work_unit_char_cd <> n.work_unit_char_cd
        or o.work_mon_inco <> n.work_mon_inco
        or o.anl_inco <> n.anl_inco
        or o.employ_year_cnt <> n.employ_year_cnt
        or o.emply_status_cd <> n.emply_status_cd
        or o.dimission_dt <> n.dimission_dt
        or o.empyt_dt <> n.empyt_dt
        or o.zip_cd <> n.zip_cd
        or o.title_cd <> n.title_cd
        or o.post_cd <> n.post_cd
        or o.career_cd <> n.career_cd
        or o.corp_work_start_year <> n.corp_work_start_year
        or o.corp_iac_que_rest_cd <> n.corp_iac_que_rest_cd
        or o.corp_rgst_dt <> n.corp_rgst_dt
        or o.corp_rgst_cap_gold <> n.corp_rgst_cap_gold
        or o.work_unit_sspf_flg <> n.work_unit_sspf_flg
        or o.work_record_cd <> n.work_record_cd
        or o.work_char_cd <> n.work_char_cd
        or o.employ_type_cd <> n.employ_type_cd
        or o.indus_risk_cate_cd <> n.indus_risk_cate_cd
        or o.trading_corp_flg <> n.trading_corp_flg
        or o.curr_indus_obtain_emply_years <> n.curr_indus_obtain_emply_years
        or o.serving_years <> n.serving_years
        or o.local_dept <> n.local_dept
        or o.other_career <> n.other_career
        or o.now_corp_work_years <> n.now_corp_work_years
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_work_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,tel_num -- 电话号码
    ,work_unit_addr -- 工作单位地址
    ,work_unit_name -- 工作单位名称
    ,work_unit_char_cd -- 工作单位性质代码
    ,work_mon_inco -- 工作月收入
    ,anl_inco -- 年收入
    ,employ_year_cnt -- 雇佣年数
    ,emply_status_cd -- 雇用状态代码
    ,dimission_dt -- 离职日期
    ,empyt_dt -- 入职日期
    ,zip_cd -- 邮政编码
    ,title_cd -- 职称代码
    ,post_cd -- 职务代码
    ,career_cd -- 职业代码
    ,corp_work_start_year -- 本单位工作起始年份
    ,corp_iac_que_rest_cd -- 单位工商查询结果代码
    ,corp_rgst_dt -- 单位注册日期
    ,corp_rgst_cap_gold -- 单位注册资本金
    ,work_unit_sspf_flg -- 工作单位与社保公积金一致标志
    ,work_record_cd -- 工作履历代码
    ,work_char_cd -- 工作性质代码
    ,employ_type_cd -- 雇佣类型代码
    ,indus_risk_cate_cd -- 行业风险类别代码
    ,trading_corp_flg -- 贸易型企业标志
    ,curr_indus_obtain_emply_years -- 目前行业从业年限
    ,serving_years -- 任职年限
    ,local_dept -- 所在部门
    ,other_career -- 其他职业
    ,now_corp_work_years -- 现单位工作年限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_work_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,tel_num -- 电话号码
    ,work_unit_addr -- 工作单位地址
    ,work_unit_name -- 工作单位名称
    ,work_unit_char_cd -- 工作单位性质代码
    ,work_mon_inco -- 工作月收入
    ,anl_inco -- 年收入
    ,employ_year_cnt -- 雇佣年数
    ,emply_status_cd -- 雇用状态代码
    ,dimission_dt -- 离职日期
    ,empyt_dt -- 入职日期
    ,zip_cd -- 邮政编码
    ,title_cd -- 职称代码
    ,post_cd -- 职务代码
    ,career_cd -- 职业代码
    ,corp_work_start_year -- 本单位工作起始年份
    ,corp_iac_que_rest_cd -- 单位工商查询结果代码
    ,corp_rgst_dt -- 单位注册日期
    ,corp_rgst_cap_gold -- 单位注册资本金
    ,work_unit_sspf_flg -- 工作单位与社保公积金一致标志
    ,work_record_cd -- 工作履历代码
    ,work_char_cd -- 工作性质代码
    ,employ_type_cd -- 雇佣类型代码
    ,indus_risk_cate_cd -- 行业风险类别代码
    ,trading_corp_flg -- 贸易型企业标志
    ,curr_indus_obtain_emply_years -- 目前行业从业年限
    ,serving_years -- 任职年限
    ,local_dept -- 所在部门
    ,other_career -- 其他职业
    ,now_corp_work_years -- 现单位工作年限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.sorc_sys_cd -- 源系统代码
    ,o.corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,o.tel_num -- 电话号码
    ,o.work_unit_addr -- 工作单位地址
    ,o.work_unit_name -- 工作单位名称
    ,o.work_unit_char_cd -- 工作单位性质代码
    ,o.work_mon_inco -- 工作月收入
    ,o.anl_inco -- 年收入
    ,o.employ_year_cnt -- 雇佣年数
    ,o.emply_status_cd -- 雇用状态代码
    ,o.dimission_dt -- 离职日期
    ,o.empyt_dt -- 入职日期
    ,o.zip_cd -- 邮政编码
    ,o.title_cd -- 职称代码
    ,o.post_cd -- 职务代码
    ,o.career_cd -- 职业代码
    ,o.corp_work_start_year -- 本单位工作起始年份
    ,o.corp_iac_que_rest_cd -- 单位工商查询结果代码
    ,o.corp_rgst_dt -- 单位注册日期
    ,o.corp_rgst_cap_gold -- 单位注册资本金
    ,o.work_unit_sspf_flg -- 工作单位与社保公积金一致标志
    ,o.work_record_cd -- 工作履历代码
    ,o.work_char_cd -- 工作性质代码
    ,o.employ_type_cd -- 雇佣类型代码
    ,o.indus_risk_cate_cd -- 行业风险类别代码
    ,o.trading_corp_flg -- 贸易型企业标志
    ,o.curr_indus_obtain_emply_years -- 目前行业从业年限
    ,o.serving_years -- 任职年限
    ,o.local_dept -- 所在部门
    ,o.other_career -- 其他职业
    ,o.now_corp_work_years -- 现单位工作年限
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_work_info_h_icmsf1_bk o
    left join ${iml_schema}.pty_party_work_info_h_icmsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_work_info_h_icmsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.sorc_sys_cd = d.sorc_sys_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_work_info_h;
--alter table ${iml_schema}.pty_party_work_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_party_work_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_party_work_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_party_work_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

whenever sqlerror exit sql.sqlcode;
-- 4.3 exchange partition
alter table ${iml_schema}.pty_party_work_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_party_work_info_h_icmsf1_cl;
alter table ${iml_schema}.pty_party_work_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_party_work_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_work_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_work_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_party_work_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_party_work_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_work_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_work_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
