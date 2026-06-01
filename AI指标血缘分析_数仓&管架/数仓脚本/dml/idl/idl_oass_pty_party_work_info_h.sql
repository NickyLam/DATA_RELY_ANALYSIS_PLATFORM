/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_party_work_info_h
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_pty_party_work_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_party_work_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_party_work_info_h (
etl_dt  --数据日期
,sorc_sys_cd  --源系统代码
,corp_bl_induty_type_cd  --单位所属行业类型代码
,tel_num  --电话号码
,work_unit_addr  --工作单位地址
,work_unit_name  --工作单位名称
,work_unit_char_cd  --工作单位性质代码
,work_mon_inco  --工作月收入
,anl_inco  --年收入
,employ_year_cnt  --雇佣年数
,emply_status_cd  --雇用状态代码
,dimission_dt  --离职日期
,empyt_dt  --入职日期
,zip_cd  --邮政编码
,title_cd  --职称代码
,post_cd  --职务代码
,career_cd  --职业代码
,corp_work_start_year  --加入本单位日期
,corp_iac_que_rest_cd  --单位工商查询结果代码
,corp_rgst_dt  --单位注册日期
,corp_rgst_cap_gold  --单位注册资本金
,work_unit_sspf_flg  --工作单位与社保公积金一致标志
,work_record_cd  --工作履历代码
,work_char_cd  --工作性质代码
,employ_type_cd  --雇佣类型代码
,indus_risk_cate_cd  --行业风险类别代码
,trading_corp_flg  --贸易型企业标志
,curr_indus_obtain_emply_years  --目前行业从业年限
,serving_years  --任职年限
,local_dept  --所在部门
,other_career  --其他职业
,now_corp_work_years  --现单位工作年限
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd --源系统代码
,replace(replace(t1.corp_bl_induty_type_cd,chr(13),''),chr(10),'') as corp_bl_induty_type_cd --单位所属行业类型代码
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num --电话号码
,replace(replace(t1.work_unit_addr,chr(13),''),chr(10),'') as work_unit_addr --工作单位地址
,replace(replace(t1.work_unit_name,chr(13),''),chr(10),'') as work_unit_name --工作单位名称
,replace(replace(t1.work_unit_char_cd,chr(13),''),chr(10),'') as work_unit_char_cd --工作单位性质代码
,t1.work_mon_inco as work_mon_inco --工作月收入
,t1.anl_inco as anl_inco --年收入
,t1.employ_year_cnt as employ_year_cnt --雇佣年数
,replace(replace(t1.emply_status_cd,chr(13),''),chr(10),'') as emply_status_cd --雇用状态代码
,t1.dimission_dt as dimission_dt --离职日期
,t1.empyt_dt as empyt_dt --入职日期
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd --邮政编码
,replace(replace(t1.title_cd,chr(13),''),chr(10),'') as title_cd --职称代码
,replace(replace(t1.post_cd,chr(13),''),chr(10),'') as post_cd --职务代码
,replace(replace(t1.career_cd,chr(13),''),chr(10),'') as career_cd --职业代码
,t1.corp_work_start_year as corp_work_start_year --加入本单位日期
,replace(replace(t1.corp_iac_que_rest_cd,chr(13),''),chr(10),'') as corp_iac_que_rest_cd --单位工商查询结果代码
,t1.corp_rgst_dt as corp_rgst_dt --单位注册日期
,t1.corp_rgst_cap_gold as corp_rgst_cap_gold --单位注册资本金
,replace(replace(t1.work_unit_sspf_flg,chr(13),''),chr(10),'') as work_unit_sspf_flg --工作单位与社保公积金一致标志
,replace(replace(t1.work_record_cd,chr(13),''),chr(10),'') as work_record_cd --工作履历代码
,replace(replace(t1.work_char_cd,chr(13),''),chr(10),'') as work_char_cd --工作性质代码
,replace(replace(t1.employ_type_cd,chr(13),''),chr(10),'') as employ_type_cd --雇佣类型代码
,replace(replace(t1.indus_risk_cate_cd,chr(13),''),chr(10),'') as indus_risk_cate_cd --行业风险类别代码
,replace(replace(t1.trading_corp_flg,chr(13),''),chr(10),'') as trading_corp_flg --贸易型企业标志
,t1.curr_indus_obtain_emply_years as curr_indus_obtain_emply_years --目前行业从业年限
,t1.serving_years as serving_years --任职年限
,replace(replace(t1.local_dept,chr(13),''),chr(10),'') as local_dept --所在部门
,replace(replace(t1.other_career,chr(13),''),chr(10),'') as other_career --其他职业
,t1.now_corp_work_years as now_corp_work_years --现单位工作年限
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_party_work_info_h t1    --当事人工作信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_party_work_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
