/*
Questão 01.
Ao realizar um curso o aluno ganha créditos.
Ao eliminar um curso da lista do aluno, os seus créditos totais deverão ser reduzidos.
Construa uma Trigger chamada dbo.lost_credits que atualiza o valor de créditos de um aluno após a retirada de um curso da sua lista.
*/

CREATE TRIGGER dbo.lost_credits
ON dbo.takes
AFTER DELETE AS
IF (ROWCOUNT_BIG() = 0)
RETURN;
BEGIN
	UPDATE dbo.student
    SET tot_cred = tot_cred - (SELECT credits FROM dbo.course INNER JOIN deleted ON course.course_id = deleted.course_id) 
    WHERE student.id = (SELECT DISTINCT ID FROM deleted);	
END

-- O estudante selecionado será '30299'
SELECT * FROM takes t WHERE t.ID = '30299' ORDER BY t.course_id;

-- Atualmente o aluno possui 41 créditos
SELECT ID, name, dept_name, tot_cred FROM student WHERE ID = '30299';

-- Eliminação de um curso realizado pelo aluno '30299'
DELETE FROM takes WHERE ID = '30299' AND course_id = '105' AND sec_id = '1' AND semester = 'Fall' AND [year] = 2009;

-- A pontuação do aluno será atualizada para 38. Menos 3 créditos.
SELECT ID, name, dept_name, tot_cred FROM student WHERE ID = '30299';


